pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps { checkout scm }
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
        stage('Docker Build') {
            steps {
                sh 'docker build -t nextgen-app:${BUILD_NUMBER} .'
            }
        }
        stage('Security Scan') {
            steps {
                sh 'docker run --rm -v /var/run/docker.sock:/var/run/docker.sock aquasec/trivy:latest image --exit-code 0 --severity HIGH,CRITICAL nextgen-app:${BUILD_NUMBER}'
            }
        }
        stage('Deploy Report') {
            steps {
                echo 'Pipeline completed successfully'
                sh 'docker images | grep nextgen-app'
            }
        }
    }
}