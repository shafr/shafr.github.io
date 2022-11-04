freeStyleJob('run-blackduck-scan') {
    logRotator(-1, 100)
    label 'k8s-microservices-node'

    triggers {
        // Run every monday at 8:00 Prague Time / 00:00 Denver Time
        cron('0 0 * * 1')
    }

    parameters {

    }

    wrappers {
        timestamps()
        colorizeOutput 'xterm'
        credentialsBinding {
            string('BLACKDUCK_API_TOKEN', 'blackduck-api-token')
        }
        timeout {
            absolute(60)
            failBuild()
            writeDescription('BlackDuck scan haven\'t finsihed within {0} minutes')
        }
    }

    steps {
        shell '''\
        #!/bin/bash -e
        ./bin/blackduck_scan.sh
        bash -x blackduck_get_report.sh
        cd bin
        source ~/.nvm/nvm.sh
        nvm use v16.3.0
        cat vulnerable-bom-components.json | node audit-transform.js > audit-issues.json
        '''.stripIndent()
    }

    publishers {
        archiveArtifacts {
            pattern 'bin/project.json'
            //in case of cache
            allowEmpty true
        }
        archiveArtifacts('bin/version.json')
        archiveArtifacts('bin/audit-issues.json')
        archiveArtifacts('bin/vulnerable-bom-components.json')
        archiveArtifacts('bin/scan-info.txt')

        recordIssues{
            tools {
                issues{
                    name("Black Duck Scan Results")
                    pattern('bin/audit-issues.json')
                }
            }
            qualityGates{
               qualityGate{
                   threshold(1)
                   type('TOTAL_ERROR')
                   unstable(true)
               }
            }
        }
    }
}