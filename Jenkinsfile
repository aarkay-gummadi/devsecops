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
                sh 'docker image build -t bangarujyothiswar/netflix:$BUILD_ID .'
            }
        }
        stage('Trivy Scan') {
            steps {
                script {
                    sh 'trivy image --format json -o trivy-report.json bangarujyothiswar/netflix:$BUILD_ID'
                }
                publishHTML([reportName: 'Trivy Vulnerability Report', reportDir: '.', reportFiles: 'trivy-report.json', keepAll: true, alwaysLinkToLastBuild: true, allowMissing: false])
            }
        }
        stage('login to dockerhub') {
    	    steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }    
        }
        stage('push image to dockerhub') {
            steps {
                sh 'docker image push bangarujyothiswar/netflix:$BUILD_ID'
            }
        }
    }
}