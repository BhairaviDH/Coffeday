pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }

    stages {

        stage("Clean Workspace") {
            steps {
                cleanWs()
            }
        }

        stage("Git Checkout") {
            steps {
                git branch: 'main',
                    url: 'https://github.com/BhairaviDH/Coffeday.git'
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

                        // Update Kubernetes deployment image
                        sh """
                        sed -i 's|image: .*|image: dadda5/coffday:${BUILD_NUMBER}|' k8s/deployment.yaml
                        """

                        // Git configuration
                        sh 'git config --global user.name "Jenkins"'
                        sh 'git config --global user.email "jenkins@local"'

                        // Commit updated deployment file
                        sh "git add k8s/deployment.yaml"
                        sh "git commit -m 'Update image to ${BUILD_NUMBER}' || true"

                        // Push using GitHub credentials
                        withCredentials([usernamePassword(
                            credentialsId: 'github',
                            usernameVariable: 'GIT_USER',
                            passwordVariable: 'GIT_TOKEN'
                        )]) {

                            sh """
                            git remote set-url origin https://${GIT_USER}:${GIT_TOKEN}@github.com/BhairaviDH/Coffeday.git
                            git push origin HEAD:main
                            """
                        }
                    }
                }
            }
        }
    }
}
