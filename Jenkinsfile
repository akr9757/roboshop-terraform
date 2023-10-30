pipeline {

  agent {
    node {
      label 'workstation'
    }
  }

  parameters {
    choice(name: 'env', choices: ['dev', 'prod'], description: 'Pick environment')
  }

  stages {
    stage {'terraform init'}
      steps {
        sh 'terraform init -backend-config=env-${env}/state.tfvars'
      }


    stage {'terraform apply'}
      steps {
        sh 'terraform init -auto-approve -var-file=env-${env}/main.tfvars'
      }
    }
  }

  post {
    always {
      cleanws()
    }
  }
}