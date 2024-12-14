pipeline {
	agent any

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
	}
 
}
