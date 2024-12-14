pipeline {
	agent any
	environment {
		IMAGE_TAG = 'latest'
	        ECR_REPO = 'real-estate-repo'
	        ECR_REGISTRY = '381492139836.dkr.ecr.us-west-2.amazonaws.com'
	        //ECS_CLUSTER = 'real-estate-cluster'
	        //ECS_SERVICE = 'real-estate-service'
	        //ECS_TASK_DEFINITION = 'real-estate-taskdef'
	        TRIVY_IMAGE = "${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
	}
	stages {

		stage('Checkout Git') {
			steps {
				git branch: 'main', changelog: false, url: 'https://github.com/max-az-10/real-estate.git'
			}
		}
		stage('CSonarQube Analysis') {
			steps {
				script {
					def scannerHome = tool 'SonarQube Scanner';
					withSonarQubeEnv('SonarQube') {
					      sh "${scannerHome}/bin/sonar-scanner"
					}
				}
			}	
		}
		stage('Build & Tag image') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'Aws_cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {	
					script {
						sh """
						docker build -t ${ECR_REPO}:${IMAGE_TAG} .
	     					docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
						"""
					}
				}	
			}
		}
		stage('Trivy scan') {
			steps {
				script {
					sh "trivy image --severity HIGH,MEDIUM --format table -o trivy-report.html ${TRIVY_IMAGE}"
				}
			}
		}
		stage('Login & Push to ECR') {
			steps {
				withCredentials([usernamePassword(credentialsId: 'Aws_cred', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {
					script {
						sh """
						aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ECR_REGISTRY
      						aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 381492139836.dkr.ecr.us-west-2.amazonaws.com
                        			docker push $ECR_REGISTRY/$ECR_REPO:$IMAGE_TAG
	    					"""
					}
				}
			}
		}		
	}		
}
