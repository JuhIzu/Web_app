import groovy.json.JsonSlurper

def getAcrLoginServer(def acrSettingsJson) {
  def acrSettings = new JsonSlurper().parseText(acrSettingsJson)
  return acrSettings.loginServer
}

node {
 withEnv(['AZURE_SUBSCRIPTION_ID=6d369cd7-e453-4edf-aafe-ba90de47f386',
        'AZURE_TENANT_ID=bceba7fc-937d-449b-bec8-d1cf87b0c6c7']) {
    stage('init') {
      checkout scm
    } 
  
    stage('deploy') {
      def webAppResourceGroup = 'ResourceGroup_Assign2'
      def webAppName = 'Assign2app'
      def acrName = 'acrAssign2'
      def imageName = 'assignment'
      // generate version, it's important to remove the trailing new line in git describe output
      def version = sh script: 'git describe | tr -d "\n"', returnStdout: true
      withCredentials([usernamePassword(credentialsId: 'servicePrincipal_Assign2', passwordVariable: 'AZURE_CLIENT_SECRET', usernameVariable: 'AZURE_CLIENT_ID')]) {
        // login Azure
        sh '''
          az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID
          az account set -s $AZURE_SUBSCRIPTION_ID
        '''
         // get login server
        def acrSettingsJson = sh script: "az acr show -n $acrName", returnStdout: true
        def loginServer = getAcrLoginServer acrSettingsJson
        // login docker
        // docker.withRegistry only supports credential ID, so use native docker command to login
        // you can also use docker.withRegistry if you add a credential
        sh "docker login -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET $loginServer"
        // build image
        
        //sh "docker build --tag user-service-custom-image ."
        //sh "docker run -p 8000:8000 user-service-custom-image"
        
        def imageWithTag = "$loginServer/$imageName"
        def image = docker.build imageWithTag
        // push image
        image.push()
        // update web app docker settings
        sh "az webapp config container set -g $webAppResourceGroup -n $webAppName -c $imageWithTag -r http://$loginServer -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET"
        // log out
        sh 'az logout'
        sh "docker logout $loginServer"
      }
    }
  }
}
