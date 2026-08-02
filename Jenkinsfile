pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }
    stages {
        stage ("Clean Workspace") {
            steps {
                cleanWs()
            }
        }
        stage ("Git Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/tpp-tpp/Starbucks-Application.git'
            }
        }
        stage("Install NPM Dependencies") {
            steps {
                sh "npm install"
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build -t starbucks ."
            }
        }
        stage("Tag & Push to DockerHub") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker') {
                        sh "docker tag starbucks dadda5/starbucks:${BUILD_NUMBER}"
                        sh "docker push dadda5/starbucks:${BUILD_NUMBER}"
                    }
                }
            }
        }
        stage('Deploy to GKE') {
    steps {
        withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_KEY')]) {
            sh """
                gcloud auth activate-service-account --key-file=$GOOGLE_KEY

                gcloud config set project planar-momentum-500811-e0

                gcloud container clusters get-credentials clusterstarbut --region us-east1

                kubectl apply -f k8s/

                kubectl set image deployment/starbucks-deployment \
                starbucks=dadda5/starbucks:${BUILD_NUMBER}

                kubectl rollout status deployment/starbucks-deployment
            """
        }
    }
}
        
}
}
