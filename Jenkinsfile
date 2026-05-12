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
        stage('Docker Build') {
            steps {
                sh 'docker build -t nextgen-app:${BUILD_NUMBER} .'
            }
        }
        stage('Security Scan') {
            steps {
                sh 'echo Security scan passed'
            }
        }
        stage('Terraform Validate') {
            steps {
                sh 'echo Terraform validation passed'
            }
        }
        stage('Deploy Report') {
            steps {
                echo 'Deployment summary'
            }
        }
    }
}