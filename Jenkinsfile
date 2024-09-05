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
               publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/pipeline\ project/target/surefire-reports', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                    }
            }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t pradeep82kumar/staragileprojectfinance:v2 .'
                    sh 'docker images'
                }
            }
        }
         
        
     stage('Deploy') {
            steps {
                sh 'sudo docker run -itd --name My-first-containe21211 -p 8083:8081 pradeep82kumar/staragileprojectfinance:v2'
                  
                }
            }
        
    }
}
