def functions = ['MoviesStoreListMovies', 'MoviesStoreSearchMovie', 'MoviesStoreViewFavorites', 'MoviesStoreAddToFavorites']
def environments = ['master':'production', 'preprod':'staging', 'develop':'sandbox']
def imageName = 'mlabouardy/movies-store'
def bucket = 'deployment-packages-watchlist'
def region = 'eu-west-3'

node('workers'){
    try {
        stage('Checkout'){
            checkout scm
            notifySlack('STARTED')
        }


        def imageTest= docker.build("${imageName}-test", "-f Dockerfile.test .")

        stage('Tests'){
            parallel(
                'Quality Tests': {
                    sh "docker run --rm ${imageName}-test npm run lint"
                },
                'Unit Tests': {
                    sh "docker run --rm ${imageName}-test npm run test"
                },
                'Coverage Reports': {
                    sh "docker run --rm -v $PWD/coverage:/app/coverage ${imageName}-test npm run coverage"
                    publishHTML (target: [
                        allowMissing: false,
                        alwaysLinkToLastBuild: false,
                        keepAll: true,
                        reportDir: "$PWD/coverage",
                        reportFiles: "index.html",
                        reportName: "Coverage Report"
                    ])
                }
            )
        }

        stage('Build'){
            sh """
                docker build -t ${imageName} .
                containerName=\$(docker run -d ${imageName})
                docker cp \$containerName:/app/node_modules node_modules
                docker rm -f \$containerName
                zip -r ${commitID()}.zip node_modules src
            """
        }

        stage('Push'){
            /*functions.each { function ->
                sh "aws s3 cp ${commitID()}.zip s3://${bucket}/${function}/"
            }*/
            def fileName = commitID()
            def parallelStagesMap = functions.collectEntries {
                ["${it}" : {
                    stage("Lambda: ${it}") {
                        sh "aws s3 cp ${fileName}.zip s3://${bucket}/${it}/"
                    }
                }]
            }
            parallel parallelStagesMap
        }

        stage('Deploy'){
            def fileName = commitID()
            def parallelStagesMap = functions.collectEntries {
                ["${it}" : {
                    stage("Lambda: ${it}") {
                        sh "aws lambda update-function-code --function-name ${it} \
                            --s3-bucket ${bucket} --s3-key ${it}/${fileName}.zip \
                            --region ${region}"

                        def version = sh(
                            script: "aws lambda publish-version --function-name ${it} \
                                         --description ${fileName} --region ${region} | jq -r '.Version'",
                            returnStdout: true
                        ).trim()

                        if (env.BRANCH_NAME == 'preprod' || env.BRANCH_NAME == 'develop'){
                            sh "aws lambda update-alias  --function-name ${it} \
                                 --name ${environments[env.BRANCH_NAME]} --function-version ${version}\
                                 --region ${region}"
                        }

                        if(env.BRANCH_NAME == 'master'){
                            timeout(time: 2, unit: "HOURS") {
                                input message: "Deploy to production?", ok: "Yes"
                            }
                            sh "aws lambda update-alias  --function-name ${it} \
                                 --name ${environments[env.BRANCH_NAME]} --function-version ${version}\
                                 --region ${region}"
                        }
                    }
                }]
            }
            parallel parallelStagesMap
        }
    } catch(e){
        currentBuild.result = 'FAILED'
        throw e
    } finally {
        notifySlack(currentBuild.result)
        sh "rm -rf ${commitID()}.zip"

        if (env.BRANCH_NAME == 'master'){
            sendEmail(currentBuild.result)
        }
    }
}

def sendEmail(String buildStatus){
    buildStatus =  buildStatus ?: 'SUCCESSFUL'
    emailext body: "More info at: ${env.BUILD_URL}",
             subject: "Name: '${env.JOB_NAME}' Status: ${buildStatus}",
             to: '$DEFAULT_RECIPIENTS'
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