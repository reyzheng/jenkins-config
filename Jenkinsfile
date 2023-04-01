pipeline {
    agent any
    options {
        timestamps ()
        //skipDefaultCheckout true
    }
    stages {
        // pre-requisite stage
        stage("init-pipelineframework") {
            steps {
                script {
                    //dir(".pf-config") {
                    //    checkout scm
                    //    stash name: "pf-config", includes: "**"
                    //}
                    dir(".pf-framework") {
                        // issues of git plugin
                        // 1. erased directory
                        // 2. https ssl problem
                        // and checkout to devsecops is necessary
                        // to avoid .git already existed problem
                        deleteDir()
                        if (isUnix() == true) {
                            sh "GIT_SSL_NO_VERIFY=true git clone https://github.com/reyzheng/jenkins-pipeline.git --depth 1 -b main ."
                        }
                        else {
                            bat "set GIT_SSL_NO_VERIFY=true && git clone https://github.com/reyzheng/jenkins-pipeline.git --depth 1 -b main ."
                        }
                        stash name: "pf-framework", includes: "**"
                    }
                    unstash name: "pf-framework"
                    //unstash name: "pf-config"
                    pipelineAsCode = load("rtk_stages.groovy")
                    pipelineAsCode.init()
                    pipelineAsCode.start()
                }
            }
        }
    }

	
    post {
        always {
            script {
                pipelineAsCode.preparePostStage()
                dir ("scripts") {
                    logParser failBuildOnError: true, showGraphs:true, unstableOnWarning: true, useProjectRule: true, projectRulePath: 'logParserRule'
                }
                pipelineAsCode.postStage("always")
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
