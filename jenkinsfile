pipeline {
    agent any
      parameters {
        choice(
            name: 'Environment',
            choices: ['main', 'dev', 'qa'],
            description: 'Please Select env'
        )
    }
     tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven"
    }
    environment {
        GIT_URL = "https://github.com/choudharyjayant/sample-java-project-jenkins-codedeploy.git"
        ARTIFACT_BUILD = "jb-hello-world-maven-0.2.0.jar"
        Zip_Name = "${BUILD_NUMBER}.zip"
        Application_name = "${params.Environment}-${JOB_NAME}"
        DeploymentGroup_Name = "DG-${params.Environment}-${JOB_NAME}"
        bucket_name = "${params.Environment}-${JOB_NAME}"
        SONAR_TOKEN = credentials('SONAR_TOKEN')
        HOST_URL = "https://sonarcloud.io"
        PROJECT_KEY = "java-maven-sonar"
        //ORGANIZATION = "jenkins-prefav"
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/choudharyjayant/sample-java-project-jenkins-codedeploy.git'
            }
        }
        stage('verifying tools') {
            steps {
                sh ''' #! /bin/bash
                java -version
		        mvn --version
                '''
            }
        }
        stage('Build') {
            steps {
                sh ''' #! /bin/bash
                #Ignoring test cases 
                mvn install -DskipTests
                mvn verify org.sonarsource.scanner.maven:sonar-maven-plugin:sonar -Dsonar.projectKey=$PROJECT_KEY -Dsonar.login=$SONAR_TOKEN
                
                '''
            }
        }
        stage ('Test') {
            steps {
                sh ''' #! /bin/bash
                mvn test
                '''
            }
        }
		stage ('Artifact') {
               steps {
               withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred-2']]) {
      
                sh """ #!/bin/bash               
                sudo zip -r ${env.Zip_Name} appspec.yml Dependency_Scripts target/${env.ARTIFACT_BUILD}
                #To push zip folder to s3 
                aws s3 cp ${env.Zip_Name}  s3://${env.bucket_name}/
                """
            }
        }
		}
        stage('Deploy') {
            steps {
            withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred-2']]) {
                sh """ #! /bin/bash/
                #to deploy on aws from s3 bucket
              
                aws deploy create-deployment --application-name ${env.Application_name} --deployment-group-name ${env.DeploymentGroup_Name} --deployment-config-name CodeDeployDefault.AllAtOnce --s3-location bucket=${env.bucket_name},bundleType=zip,key=${env.Zip_Name}
                """
            }
            }
        }
       
    }
    post {
        always {
            echo 'Stage is success'
        }
    }
    }
