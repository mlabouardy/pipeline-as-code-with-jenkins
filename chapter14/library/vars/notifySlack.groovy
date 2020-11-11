#!/usr/bin/env groovy

def call(String buildStatus) {
  buildStatus =  buildStatus ?: 'SUCCESSFUL'
  def colorCode = '#FF0000'
  def subject = "Name: '${env.JOB_NAME}'\nStatus: ${buildStatus}\nBuild ID: ${env.BUILD_NUMBER}" 
  def summary = "${subject}\nMessage: ${commitMessage()}\nAuthor: ${commitAuthor()}\nURL: ${env.BUILD_URL}"

  if (buildStatus == 'STARTED') {
    colorCode = '#546e7a'
  } else if (buildStatus == 'SUCCESSFUL') {
    colorCode = '#2e7d32'
  } else {
    colorCode = '#c62828c'
  }

  slackSend (color: colorCode, message: summary)
}