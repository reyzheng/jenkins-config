pipeline {
    agent any
    stages {
        // pre-requisite stage
        stage("Init") {
            steps {
                script {
                    dir('devsecops') {
                        // issues of git plugin
                        // 1. erased directory
                        // 2. https ssl problem
                        // and checkout to devsecops is necessary
                        // to avoid .git already existed problem
                        deleteDir()
                        if (isUnix() == true) {
                            sh "GIT_SSL_NO_VERIFY=true git clone https://mirror.rtkbf.com/gerrit/sdlc/jenkins-pipeline --depth 1 -b develop ."
                        }
                        else {
                            bat "set GIT_SSL_NO_VERIFY=true && git clone https://mirror.rtkbf.com/gerrit/sdlc/jenkins-pipeline --depth 1 -b stable ."
                        }
                    }
                    if (isUnix() == true) {
                        sh 'cp -a devsecops/* ./'
                    }
                    else {
                        bat "xcopy devsecops\\* .\\ /E /H /Y"
                    }
                    pipelineAsCode = load("rtk_stages.groovy")
                    pipelineAsCode.init()
                }
            }
        }
        stage("Start") {
            steps {
                script {
	                pipelineAsCode.start()
                }
            }
        }
    }

	
    post {
        always {
            script {
                // enable logParser if scripts/logParserRule existed
                logParser failBuildOnError: true, showGraphs:true, unstableOnWarning: true, useProjectRule: true, projectRulePath: './scripts/logParserRule'
                pipelineAsCode.postStage("always")
                pipelineAsCode.emailNotification()
            }
        }
        success {
            script {
                pipelineAsCode.postStage("success")
			}        
        }
        failure {
            script {
                pipelineAsCode.postStage("failure")
            }            
        }
        unstable {
            script {
                pipelineAsCode.postStage("unstable")
            }            
        }
        changed {
            script {
                pipelineAsCode.postStage("changed")
            }            
        }
    }
}
