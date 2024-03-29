#!groovy
// Scripted pipeline

node("media") {
  timestamps {
    git branch: 'master',
        url: 'https://github.com/paulcosma/com-paulcosma.git'
    def GIT_TAG = gitTagName()
    properties([
        buildDiscarder(logRotator(daysToKeepStr: '14', numToKeepStr: '3')),
//        pipelineTriggers([cron('@weekly')]),
    ])
    stage('CheckOut code from git tag') {
      checkout([$class: 'GitSCM', branches: [[name: "refs/tags/${GIT_TAG}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'SubmoduleOption', disableSubmodules: false, parentCredentials: false, recursiveSubmodules: false, reference: '', trackingSubmodules: false]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: "963308e5-d6be-4086-909f-2e94ebaada7f", url: "git@github.com:paulcosma/com-paulcosma.git"]]])
    }
    stage('DockerHub registry login') {
      withCredentials([usernamePassword(credentialsId: '052cba25-f00d-4ff2-b593-4e143b90515a', usernameVariable: 'dockerhub_user', passwordVariable: 'dockerhub_password')]) {
        sh "docker login -u ${dockerhub_user} -p ${dockerhub_password}"
      }
    }
    stage('Build image') {
      sh "docker image build -f Dockerfile -t paulcosma/com-paulcosma:${GIT_TAG} ."
    }
    stage('Tag image as latest') {
      sh "docker image tag paulcosma/com-paulcosma:${GIT_TAG} paulcosma/com-paulcosma:latest"
    }
    stage('Push image') {
      sh "docker image push paulcosma/com-paulcosma:${GIT_TAG}"
      sh "docker image push paulcosma/com-paulcosma:latest"
    }
    stage('Start deployments') {
      parallel(
          docker_apps: {
            build job: 'DEPLOY-docker-apps'
          }
      )
    }
  }
}

String gitTagName() {
  commit = getLatestTaggedCommit()
  sh "echo Debug: commit = $commit"
  if (commit) {
    desc = sh(script: "git describe --tags ${commit}", returnStdout: true)?.trim()
    sh "echo Debug: Tag = $desc"
  }
  return desc
}

String getLatestTaggedCommit() {
  return sh(script: 'git rev-list --tags --max-count=1', returnStdout: true)?.trim()
}
