pipeline {
    agent any  

    environment {
        KUBECONFIG = credentials('swish-test')   // Jenkins credentials to store kubeconfig
    }

    stages 

        stage('Build Maven') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/khana/swish-repo.git']]])
                sh 'mvn clean install'
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://hub.docker.com', 'khana88') {
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
                withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                    sh 'kubectl apply -f kubernetes/deployment.yaml'
                    sh 'kubectl get all'
                }
            }
        }
    }

