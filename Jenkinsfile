pipeline {
    agent any  

    environment {
        KUBECONFIG = credentials('swish-test')   // Jenkins credentials to store kubeconfig
    }

    stages {

        stage('Checkout') {
            steps {
                git(
                    credentialsId: 'cb3ff1bd-ddc7-45fa-9fc0-36f68309366f',
                    url: 'https://my-workspace21-admin@bitbucket.org/my-workspace21/swish-test.git',
                    branch: 'main'
                )
            }
        }

        stage('Build Maven') {
            steps {
                script {
                    // Ensure the correct repository and branch are used
                    checkout([$class: 'GitSCM', 
                              branches: [[name: '*/main']], 
                              userRemoteConfigs: [[url: 'https://my-workspace21-admin@bitbucket.org/my-workspace21/swish-test.git']]
                    ])
                    sh 'mvn clean install'
                }
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
                script {
                    withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') {
                        sh 'kubectl apply -f kubernetes/deployment.yaml'
                        sh 'kubectl get all'
                    }
                }
            }
        }
    }
}
