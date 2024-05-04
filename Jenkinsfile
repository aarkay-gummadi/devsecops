pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
    }
    stages {
        stage('clean workspace') {
            steps {
                cleanWs ()
            }
        }
        stage('checkout from Git') {
            steps {
                git branch: 'main', url: 'https://github.com/aarkay-gummadi/main-project.git'
            }
        }
        stage('Build docker images') {
            steps {
                sh 'docker build -t rajkumar207/netflix:$BUILD_ID .'
                echo 'Build Image Completed'
            }
        }
        stage('Trivy Scan') {
            steps {
                script {
                    sh 'trivy image --format json -o trivy-report.json rajkumar207/netflix:$BUILD_ID'
                }
                publishHTML([reportName: 'Trivy Vulnerability Report', reportDir: '.', reportFiles: 'trivy-report.json', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
                echo 'trivy scan completed'
            }
        }
        stage('login to dockerhub') {
    	    steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
                echo 'dockerhub login completed'
            }    
        }
        stage('push image to dockerhub') {
            steps {
                sh 'docker push rajkumar207/netflix:$BUILD_ID'
                echo 'Push Image to dockerhub Completed'
            }
        }
    }
}