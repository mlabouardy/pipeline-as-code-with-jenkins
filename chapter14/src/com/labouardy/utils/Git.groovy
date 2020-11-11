#!/usr/bin/env groovy
package com.labouardy.utils

class Git {

    Git(){}
    
    def commitAuthor() {
        sh 'git show -s --pretty=%an > .git/commitAuthor'
        def commitAuthor = readFile('.git/commitAuthor').trim()
        sh 'rm .git/commitAuthor'
        commitAuthor
    }

    def commitID() {
        sh 'git rev-parse HEAD > .git/commitID'
        def commitID = readFile('.git/commitID').trim()
        sh 'rm .git/commitID'
        commitID
    }

    def commitMessage() {
        sh 'git log --format=%B -n 1 HEAD > .git/commitMessage'
        def commitMessage = readFile('.git/commitMessage').trim()
        sh 'rm .git/commitMessage' 
        commitMessage
    }
}