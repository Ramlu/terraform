pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

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
                    sh 'terraform plan -out tfplan'
                    sh 'terraform show -no-color tfplan > tfplan.txt'
                }
            }
        }

        // stage('Terraform Apply') {
        //     steps {
        //         script {
        //             sh 'terraform apply -auto-approve tfplan'
        //         }
        //     }
        // }
        
        // stage('Terraform Destroy') {
        //     steps {
        //         script {
        //             // Create a destroy plan first
        //             sh 'terraform plan -destroy -out=tfplan-destroy'
        //             // Then apply the destroy plan
        //             sh 'terraform apply -auto-approve tfplan-destroy'
        //         }
        //     }
        // }

        stage('Apply / Destroy') {
            steps {
                script {
                    if (params.action == 'apply') {
                        if (!params.autoApprove) {
                            def plan = readFile 'tfplan.txt'
                            input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                        }

                        sh 'terraform ${action} -input=false tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform ${action} --auto-approve'
                    } else {
                        error "Invalid action selected. Please choose either 'apply' or 'destroy'."
                    }
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
