pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id')
    }

    stages {
        stage('Fetch Code') {
            steps {
                git branch: 'dev', url: 'https://github.com/arunmithra/aruncapstoneproject.git' 
                echo 'Git Checkout Completed'
            }
        }
        stage('Determine Branch Name') {
            steps {
                script {
                    // Fetch the branch name using a shell command
                    env.GIT_BRANCH = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                    echo "GIT_BRANCH: ${env.GIT_BRANCH}"
                }
            }
        }
        
        stage('Build') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'dev') {
                        sh './build.sh'
                    }
                }
            }
        }
        
        
        
        stage('Push') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'dev') {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
                            sh "echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin"
                            sh "docker push arundockerhub2024/dev"
                        }
                    } else if (env.GIT_BRANCH == 'master') {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials-id', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
                            sh "echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin"
                            sh "docker push arundockerhub2024/prod"
                        }
                    }
                }
                echo 'Push Image Completed'
            }
        }
        
        stage('Deploy') {
            steps {
                script {
                    if (env.GIT_BRANCH == 'dev' || env.GIT_BRANCH == 'master') {
                        sh './deploy.sh'
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout'
        }
    }
}
