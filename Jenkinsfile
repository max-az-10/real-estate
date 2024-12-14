pipeline {
	agent any

	stages {

		stage('Checkout Git') {
			steps {
				git branch: 'main', changelog: false, url: 'https://github.com/max-az-10/real-estate.git'
			}
		}
	}
 
}
