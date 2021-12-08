#! /usr/bin/env groovy

pipeline {
  agent { label 'docker' }

  environment {
    // Make sure we're ignoring any override files that may be present
    COMPOSE_FILE = "docker-compose.yml"
  }

  stages {
    stage('Build') {
      steps {
        dockerCacheLoad(image: 'tests')
        sh 'docker-compose build --pull'
      }
    }
    stage('Test') {
      steps {
        sh 'docker-compose run --rm -T tests'
      }
    }
  }

  post {
    success {
        dockerCacheStore(image: 'tests')
    }
    cleanup {
      sh 'docker-compose down --remove-orphans --rmi all'
    }
  }
}
