
pipeline {
    agent any

    environment {
        APP_NAME = 'TaskFlow'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Downloading source code from GitHub'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Installing application dependencies'

                sh '''
                    python3 -m venv .venv
                    .venv/bin/pip install --upgrade pip
                    .venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo 'Running automated tests'

                sh '''
                    .venv/bin/pytest -v
                '''
            }
        }

    }

    post {
        success {
            echo 'TaskFlow CI pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Please check the console output.'
        }

        always {
            echo 'Jenkins pipeline execution finished.'
        }
    }
}
