pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Validate') {
            steps {
                sh 'test -f Dockerfile'
                sh 'test -f terraform/main.tf'
                sh 'test -f k8s/manifest.yaml'
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'sonar-scanner -Dsonar.projectKey=nextgen-devsecops -Dsonar.sources=. -Dsonar.host.url=http://host.docker.internal:9000'
                }
            }
        }
        stage('Docker Build & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker build -t $DOCKER_USER/nextgen-app:$BUILD_NUMBER .'
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh 'docker push $DOCKER_USER/nextgen-app:$BUILD_NUMBER'
                    sh 'docker logout'
                }
            }
        }
        stage('Security Scan') {
            steps {
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL --timeout 15m --no-progress $BUILD_NUMBER || true'
                echo 'Security scan completed'
            }
        }
        stage('Terraform Deploy') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY'),
                    usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')
                ]) {
                    sh 'cd terraform && terraform init -input=false'
                    sh 'cd terraform && terraform validate'
                    sh 'cd terraform && terraform apply -auto-approve -input=false -var=docker_image=$DOCKER_USER/nextgen-app:$BUILD_NUMBER'
                    sh 'cd terraform && terraform output -raw public_ip > /tmp/deployed_ip.txt 2>/dev/null || echo "N/A" > /tmp/deployed_ip.txt'
                }
            }
            post {
                failure {
                    withCredentials([
                        string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                        string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                    ]) {
                        sh 'cd terraform && terraform destroy -auto-approve -input=false || true'
                        echo 'Cleanup done after failure'
                    }
                }
            }
        }
    }
    post {
        always {
            script {
                def buildStatus = currentBuild.currentResult ?: 'UNKNOWN'
                def deployedIp = 'N/A'
                try {
                    deployedIp = sh(script: 'cat /tmp/deployed_ip.txt 2>/dev/null || echo "N/A"', returnStdout: true).trim()
                } catch(e) {
                    deployedIp = 'N/A'
                }
                def deployedUrl = (deployedIp != 'N/A' && deployedIp != 'None' && deployedIp != '') ? 'http://' + deployedIp + ':80' : 'N/A'
                def reportData = '{"branch":"' + env.BRANCH_NAME + '","build_number":"' + env.BUILD_NUMBER + '","status":"' + buildStatus + '","duration_ms":' + currentBuild.duration + ',"deployed_url":"' + deployedUrl + '"}'
                sh "curl -s -X POST http://host.docker.internal:8000/api/v1/pipeline/report -H 'Content-Type: application/json' -d '" + reportData + "' || true"
                echo 'Report sent: ' + buildStatus + ' - URL: ' + deployedUrl
            }
        }
    }
}