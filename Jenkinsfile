pipeline {
  agent any
  stages {
    stage('create basebox') {
      steps {
        echo 'Build vagrant base boxes ubuntu-18.04'
        sh 'pwd'
        sh 'curl -sfL https://raw.githubusercontent.com/elegoev/vagrant-ubuntu-18.04/master/jenkins/scripts/create-vagrant-box.sh | bash '
        cleanWs(deleteDirs: true)
      }
    }
  }
}
