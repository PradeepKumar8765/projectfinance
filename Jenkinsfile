pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M2_HOME"
    }

    stages {
        stage('Build') {
            steps {
                git 'https://github.com/PradeepKumar8765/projectfinance.git'
                sh "mvn -Dmaven.test.failure.ignore=true clean package"
            }        
        }
        
        stage('Generate Test Reports') {
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
                withCredentials([usernamePassword(credentialsId: 'Docker-login', passwordVariable: 'dockerpassword', 
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
    }
}

