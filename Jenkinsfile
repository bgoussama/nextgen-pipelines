pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'node:16'
        DOCKER_TAG = 'latest'
        REGISTRY = 'your-registry'
        REGISTRY_CREDENTIALS = env.REGISTRY_CREDENTIALS
    }
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/bgoussama/nextgen-pipelines.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps {
                sh 'npm run test'
                sh 'npm run lint'
            }
        }
        stage('SonarQube Scan') {
            steps {
                sh 'npm run sonar'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t ${REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG} .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}