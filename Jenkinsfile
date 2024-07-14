pipeline {
    agent Jenkins   
    environment {
        KUBECONFIG = credentials('swish-test')   // Jenkins credentials to store kubeconfig
    }  
    stages {
        stage('Checkout') {
            steps {
                checkout https://github.com/khana/swish-repo.git
            }
        }       
        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com/repository/docker/khana88/swish/general', 'khana88') {
                        def app = docker.build('swish:latest', './app')
                        app.push()
                    }
                }
            }
        }        
        stage('Deploy to Kubernetes') {
            environment {
                IMAGE = 'swish:latest'
            }
            steps {
                script {
                    sh "kubectl --kubeconfig=${KUBECONFIG} apply -f kubernetes/deployment.yaml"
                    sh "kubectl --kubeconfig=${KUBECONFIG} apply -f kubernetes/service.yaml"
                }
            }
        }
    }
}
