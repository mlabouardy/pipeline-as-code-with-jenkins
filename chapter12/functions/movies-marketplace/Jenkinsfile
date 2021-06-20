def imageName = 'mlabouardy/movies-marketplace'
def bucket = 'marketplace.slowcoder.com'
def region = 'eu-west-3'
def environments = ['master':'production', 'preprod':'staging', 'develop':'sandbox']

node('workers'){
    try{
        stage('Checkout'){
            checkout scm
            notifySlack('STARTED')
        }

        def imageTest= docker.build("${imageName}-test", "-f Dockerfile.test .")

        stage('Quality Tests'){
            sh "docker run --rm ${imageName}-test npm run lint"
        }

        stage('Unit Tests'){
            sh "docker run --rm -v $PWD/coverage:/app/coverage ${imageName}-test npm run test"
            publishHTML (target: [
                allowMissing: false,
                alwaysLinkToLastBuild: false,
                keepAll: true,
                reportDir: "$PWD/coverage/marketplace",
                reportFiles: "index.html",
                reportName: "Coverage Report"
            ])
        }

        stage('Static Code Analysis'){
            withSonarQubeEnv('sonarqube') {
                sh 'sonar-scanner'
            }
        }

        stage("Quality Gate"){
            timeout(time: 5, unit: 'MINUTES') {
                def qg = waitForQualityGate()
                if (qg.status != 'OK') {
                    error "Pipeline aborted due to quality gate failure: ${qg.status}"
                }
            }
        }

        stage('Build'){
            sh """
                docker build -t ${imageName} --build-arg ENVIRONMENT=${environments[env.BRANCH_NAME]} .
                containerName=\$(docker run -d ${imageName})
                docker cp \$containerName:/app/dist dist
                docker rm -f \$containerName
            """
        }

        if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'preprod' || env.BRANCH_NAME == 'develop'){
            stage('Push'){
                sh "aws s3 cp --recursive dist/ s3://${bucket}/${environments[env.BRANCH_NAME]}/"
            }
        }
    } catch(e){
        currentBuild.result = 'FAILED'
        throw e
    } finally {
        notifySlack(currentBuild.result)
        sh 'rm -rf dist'
    }
}

def notifySlack(String buildStatus){
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


def commitAuthor(){
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