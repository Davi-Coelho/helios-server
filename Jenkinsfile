node('jenkins_sites') {

    def helios

    stage("Cleaning workspace") {
        cleanWs()
        echo "Building ${JOB_NAME}..."
    }

    stage("Cloning helios git") {
        checkout scm
    }
    
    stage("Building image") {
        helios = docker.build('registry.davicoelho.com/sistemas/helios')
    }
    
    stage("Pushing image to Harbor") {
        docker.withRegistry('https://registry.davicoelho.com', 'harbor-sistemas') {
            helios.push("${TAG}")
        }
    }

    stage("Cleaning workspace on ending") {
        cleanWs(cleanWhenNotBuilt: false,
                deleteDirs: true,
                disableDeferredWipeout: true,
                notFailBuild: true,
                patterns: [[pattern: '.gitignore', type: 'INCLUDE'],
                        [pattern: '.propsfile', type: 'EXCLUDE']])
    }
}
