import jenkins.model.*
import com.cloudbees.plugins.credentials.*
import com.cloudbees.plugins.credentials.common.*
import com.cloudbees.plugins.credentials.domains.*
import com.cloudbees.plugins.credentials.impl.*
import com.cloudbees.jenkins.plugins.sshcredentials.impl.*
import hudson.plugins.sshslaves.*;

println "--> creating SSH credentials"

domain = Domain.global()
store = Jenkins.instance.getExtensionList('com.cloudbees.plugins.credentials.SystemCredentialsProvider')[0].getStore()

slavesPrivateKey = new BasicSSHUserPrivateKey(
CredentialsScope.GLOBAL,
"jenkins-slaves",
"ec2-user",
new BasicSSHUserPrivateKey.UsersPrivateKeySource(),
"",
""
)

store.addCredentials(domain, slavesPrivateKey)