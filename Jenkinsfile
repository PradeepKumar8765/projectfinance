pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M2_HOME" and add it to the path.
        maven "M2_HOME"
    }

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/PradeepKumar8765/projectfinance.git'
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }
        }

        stage('Generate Test Report') {
            steps {
                publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false,
                             reportDir: '/var/lib/jenkins/workspace/pipeline project/target/surefire-reports',
                             reportFiles: 'index.html', reportName: 'HTML Report',
                             reportTitles: '', useWrapperFileDirectly: true])
            }
        }

        stage('Create Docker Image') {
            steps {
                sh 'docker build -t pradeep82kumar/banking-project-demo:1.0 .'
            }
        }

        stage('Docker-Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'dockerpassword',
                                                  usernameVariable: 'dockerlogin')]) {
                    sh 'docker login -u ${dockerlogin} -p ${dockerpassword}'
                }
            }
        }

        stage('Push-Image') {
            steps {
                sh 'docker push pradeep82kumar/banking-project-demo:1.0'
            }
        }

        stage('Config & Deployment') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
                                  credentialsId: 'AwsAccessKey',
                                  accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                                  secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                    dir('terraform file') {
                        sh 'sudo chmod 600 k8S.pem'
                        sh 'terraform init'
                        sh 'terraform validate'
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}
