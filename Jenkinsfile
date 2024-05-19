
pipeline {
    agent any
    
    environment {
     AWS_ACCESS_KEY_ID  = credentials('AWS_ACCESS_KEY_ID')
     AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
             
        stage('Terraform Init') {
            steps {
                // Initialize Terraform
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                // Plan Terraform changes
                sh 'terraform plan -out=tfplan'
            }
        }
        
        stage('Terraform Apply') {
            steps {
                // Apply Terraform changes
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
    
    }
