#!groovy

import jenkins.model.Jenkins
import jenkins.security.s2m.*

Jenkins jenkins = Jenkins.getInstance()

println "--> disabling JNLP"
jenkins.setSlaveAgentPort(-1)

println "--> disabling non-encrypted protocols"
HashSet<String> newProtocols = new HashSet<>(jenkins.getAgentProtocols());
newProtocols.removeAll(Arrays.asList(
        "JNLP3-connect", "JNLP2-connect", "JNLP-connect", "CLI-connect"
));
jenkins.setAgentProtocols(newProtocols);
jenkins.save()