#!groovy

import jenkins.model.Jenkins

Jenkins jenkins = Jenkins.getInstance()

println "--> disabling Jenkins remote CLI"
jenkins.CLI.get().setEnabled(false)
jenkins.save()