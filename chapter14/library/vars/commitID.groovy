#!/usr/bin/env groovy

def call() {
  sh 'git rev-parse HEAD > .git/commitID'
  def commitID = readFile('.git/commitID').trim()
  sh 'rm .git/commitID'
  commitID
}