#!/usr/bin/env groovy

def call() {
  sh 'git log --format=%B -n 1 HEAD > .git/commitMessage'
  def commitMessage = readFile('.git/commitMessage').trim()
  sh 'rm .git/commitMessage' 
  commitMessage
}