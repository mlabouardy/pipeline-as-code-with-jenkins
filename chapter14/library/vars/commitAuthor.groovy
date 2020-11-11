#!/usr/bin/env groovy

def call() {
  sh 'git show -s --pretty=%an > .git/commitAuthor'
  def commitAuthor = readFile('.git/commitAuthor').trim()
  sh 'rm .git/commitAuthor'
  commitAuthor
}