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
                git branch: 'main', url: 'https://github.com/BhairaviDH/Coffeday.git'
            }
        }
        stage("Install NPM Dependencies") {
            steps {
                sh "npm install"
            }
        }
        stage("Build Docker Image") {
            steps {
                sh "docker build -t coffday ."
            }
        }
        stage("Tag & Push to DockerHub") {
            steps {
                script {
                    withDockerRegistry(credentialsId: 'docker') {
                        sh "docker tag coffday dadda5/coffday:${BUILD_NUMBER}"
sh "docker push dadda5/coffday:${BUILD_NUMBER}"

sh "docker tag coffday dadda5/coffday:latest"
sh "docker push dadda5/coffday:latest"
                    }
                }
            }
        }
      

               
  
        
}
}
