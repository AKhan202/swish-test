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


------------
pipeline {
    agent {
        label "docker"
    }
    stages {
        stage('Build Maven') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'http://git.kodekloud.com:3000/max/playground-project.git']]])
                sh 'mvn clean install'
            }
        }
        stage('Build docker image') {
            steps {
                script {
                    sh 'docker build -t docker-host:5000/playground-image:public .'
                }
            }
        }
        stage('Push image to hub') {
            steps {
                script {
                    sh 'docker login -u dock_user -p dock_password docker-host:5000'
                    sh 'docker push docker-host:5000/playground-image:public' // Corrected line
                }
            }
        }
        stage('Deploy on K8s Cluster') {
            steps {
                withKubeConfig(caCertificate: "${KUBE_CERT}", clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'my-kube-config-credentials', namespace: 'default', restrictKubeConfigAccess: false, serverUrl: 'https://jump-host:6443') 
                {
                sh 'kubectl apply -f manifests.yaml'
                sh 'kubectl get all'
                }
            }
        }    
    }
}