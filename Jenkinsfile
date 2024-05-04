pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub_credentials')
        AWS_DEFAULT_REGION='us-west-2'
        THE_BUTLER_SAYS_SO = credentials('aws_cred')
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
        stage('k8s up and running') {
            steps {
                sh 'cd deployment/terraform/aws && terraform init && terraform fmt && terraform validate && terraform plan -var-file values.tfvars && terraform $action -var-file values.tfvars --auto-approve'
            }
        }
        stage('deploy to k8s') {
            steps {
                sh 'aws eks update-kubeconfig --name my-eks-cluster'
                sh 'minikube start'
                sh 'cd deployment/k8s && kubectl apply -f deployment.yaml --validate=false'
                sh """
                kubectl patch deployment netflix-app -p '{"spec":{"template":{"spec":{"containers":[{"name":"netflix-app","image":"rajkumar207/netflix:$BUILD_ID"}]}}}}'
                """
            }
        }
        stage('kubescape scan') {
            steps {
                script {
                    sh "/usr/bin/kubescape scan -t 40 deployment/k8s/deployment.yaml --format junit -o TEST-report.xml"
                    junit "**/TEST-*.xml"
                }
            }
        }
    }
}