pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/bgoussama/nextgen-pipelines.git'
            }
        }
        stage('Build') {
            steps {
                sh 'npm install'
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
                sh 'sonar-scanner'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t my-node-app:1.0 .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}