
pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 20, unit: 'MINUTES')
    }

    environment {
        IMAGE_NAME = 'jenkins-module-6'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'python3 --version'
                sh 'docker --version'
                sh 'git rev-parse --short HEAD'
            }
        }

        stage('Install Tools') {
            steps {
                sh 'python3 -m venv .venv'
                sh '.venv/bin/python -m pip install --upgrade pip'
                sh '.venv/bin/python -m pip install -r requirements-dev.txt'
            }
        }

        stage('Unit Tests') {
            steps {
                sh '''
                    .venv/bin/python -m pytest -v \
                        --junitxml=test-results.xml
                '''
            }
        }

        stage('Code Quality') {
            steps {
                sh '''
                    .venv/bin/python -m flake8 \
                        --output-file=flake8-report.txt \
                        app.py tests/
                '''
            }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    .venv/bin/python -m bandit \
                        -r app.py \
                        -f json \
                        -o bandit-report.json
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build \
                        -t "$IMAGE_NAME:$BUILD_NUMBER" \
                        -t "$IMAGE_NAME:latest" \
                        .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'dockerhub-creds',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_TOKEN'
                    )
                ]) {
                    sh '''
                        set -eu
                        set +x

                        VERSIONED_IMAGE="$DOCKERHUB_USERNAME/$IMAGE_NAME:$BUILD_NUMBER"
                        LATEST_IMAGE="$DOCKERHUB_USERNAME/$IMAGE_NAME:latest"

                        docker tag "$IMAGE_NAME:$BUILD_NUMBER" "$VERSIONED_IMAGE"
                        docker tag "$IMAGE_NAME:latest" "$LATEST_IMAGE"

                        echo "$DOCKERHUB_TOKEN" | docker login \
                            --username "$DOCKERHUB_USERNAME" \
                            --password-stdin

                        docker push "$VERSIONED_IMAGE"
                        docker push "$LATEST_IMAGE"

                        docker logout
                    '''
                }
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
                artifacts: 'test-results.xml,flake8-report.txt,bandit-report.json',
                allowEmptyArchive: true
            )

            echo 'CI/CD pipeline finished.'
        }

        success {
            echo 'Tests passed and Docker images were pushed!'
        }

        failure {
            echo 'Pipeline failed. Inspect the failed stage and Console Output.'
        }

        cleanup {
            echo 'Pipeline cleanup completed.'
        }
    }
}

