pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 10, unit: 'MINUTES')
    }

    parameters {
        choice(
            name: 'RUN_TESTS',
            choices: ['yes', 'no'],
            description: 'Run automated Python tests?'
        )
    }

    environment {
        APP_NAME = 'jenkins-module-3'
    }

    stages {
            stage('Main Branch Check') {
            when {
                branch 'main'
            }

            steps {
                echo 'This stage runs only on main'
            }
        }
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Source code is ready'
                sh 'pwd'
                sh 'ls -la'
            }
        }

        stage('Build and Install') {
            steps {
                echo "Preparing ${APP_NAME}"
                sh 'python3 --version'
                sh 'python3 -m venv .venv'
                sh '.venv/bin/python -m pip install --upgrade pip'
                sh '.venv/bin/python -m pip install pytest'
            }
        }

        stage('Test') {
            when {
                expression {
                    params.RUN_TESTS == 'yes'
                }
            }
            steps {
                sh '''
                    .venv/bin/python -m pytest -v --junitxml=test-results.xml
                '''
            }
        }

        stage('Package') {
            steps {
                sh '''
                    mkdir -p dist
                    tar -czf dist/source.tar.gz app.py tests Jenkinsfile
                    ls -lh dist/
                '''
            }
        }
    }

    post {
        always {
            junit(
                testResults: 'test-results.xml',
                allowEmptyResults: true
            )
            archiveArtifacts(
                artifacts: 'dist/**,test-results.xml',
                allowEmptyArchive: true
            )
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Review the Console Output.'
        }

        cleanup {
            echo 'Pipeline cleanup section completed.'
        }
    }
}
