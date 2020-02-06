#!groovy

import hudson.security.csrf.DefaultCrumbIssuer
import jenkins.model.Jenkins

println "--> enabling CSRF protection"

def instance = Jenkins.instance
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.save()