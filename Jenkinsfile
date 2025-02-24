pipeline {
    agent any

   environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/Ramlu/terraform.git'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Terraform Destroy') {
            steps {
                script {
                    // Create a destroy plan first
                    sh 'terraform plan -destroy -out=tfplan-destroy'
                    // Then apply the destroy plan
                    sh 'terraform apply -auto-approve tfplan-destroy'
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform applied successfully!'
        }

        failure {
            echo 'Terraform failed!'
        }
    }
}
