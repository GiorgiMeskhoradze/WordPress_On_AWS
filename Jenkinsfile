pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage ('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/GiorgiMeskhoradze/WordPress_On_AWS.git'
            }
        }

        stage ('Terraform Init') {
            steps {
                script {
                    sh "cd terraform/environments/dev && terraform init"
                }
            }
        }

        stage ('Terraform plan') {
            steps { 
                script {
                    sh "cd terraform/environments/dev && terraform plan"
                }
            }
        }

        stage ('Terraform apply') {
            steps {
                script {
                    sh "cd terraform/environments/dev && terraform apply --auto-approve"
                }
            }
        }

        stage ('Get Outputs') {
            steps {
                script {
                    env.RDS_ENDPOINT = sh(
                        script: "cd terraform/environments/dev && terraform output -raw rds_endpoint",
                        returnStdout: true
                    ).trim()
                    echo "RDS Endpoint: ${env.RDS_ENDPOINT}"
                }
            }
        }

        stage ('Update Ansible Vars') {
            steps {
                script {
                    sh """
                        sed -i 's|db_host: ""|db_host: "${env.RDS_ENDPOINT}"|' ansible/roles/wordpress/vars/main.yml
                    """
                }
            }
        }

        stage ('Configure Wordpress') {
            steps {
                withCredentials([string(credentialsId: 'vault-pass', variable: 'VAULT_PASS')]) {
                    sh """
                        echo "$VAULT_PASS" > /tmp/.vault_pass
                        chmod 600 /tmp/.vault_pass
                        ansible-playbook ansible/playbooks/wordpress.yml --vault-password-file /tmp/.vault_pass
                        rm -f /tmp/.vault_pass
                    """
                }
            }
        }


    }

    post {
        success {
            echo "Deployment completed successfully!"
        }
        failure {
            echo "Something failed in the pipeline."
        }
    }
}