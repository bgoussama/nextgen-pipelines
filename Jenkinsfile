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
                sh 'python -m pip install --upgrade pip'
                sh 'pip install -r requirements.txt'
            }
        }
        stage('Test') {
            steps {
                sh 'pytest --junit-xml=report.xml'
                sh 'bandit -r . -f json -o bandit.json'
                sh 'safety check --json --output safety.json'
            }
        }
        stage('SonarQube Scan') {
            steps {
                sh 'sonar-scanner'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t my-fastapi-app:1.0 .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}