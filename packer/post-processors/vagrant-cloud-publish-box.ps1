# check vagrant cloud token for packer (PACKER_VAGRANTCLOUD_TOKEN)
Write-Host "token = $env:PACKER_VAGRANTCLOUD_TOKEN"
if (-not (Test-Path env:PACKER_VAGRANTCLOUD_TOKEN)) { 
  Write-Host "Environment variable 'PACKER_VAGRANTCLOUD_TOKEN' not set" -ForegroundColor Red
} else {

  # show used token
  # Write-Host "token = $env:PACKER_VAGRANTCLOUD_TOKEN"

  # vagrant publish parameter
  $BOX_NAMESPACE = $env:BOX_NAMESPACE
  $BOX_NAME = $env:IMAGE_NAME
  $BOX_VERSION = $env:BOX_VERSION
  $BOX_PROVIDER = $env:BOX_PROVIDER
  $BOX_FILE = $env:BOX_FILE
  $BOX_DESCRIPTION = $env:BOX_DESCRIPTION
  $BOX_SHORTDESCRIPTION = $env:BOX_SHORTDESCRIPTION
  $BOX_VERSIONDESCRIPTION = $env:BOX_VERSIONDESCRIPTION
  $VAGRANT_HOSTNAME = $env:VAGRANT_HOSTNAME

  # show parameter
  Write-Host "BOX_NAMESPACE          = $BOX_NAMESPACE"
  Write-Host "BOX_NAME               = $BOX_NAME"
  Write-Host "BOX_VERSION            = $BOX_VERSION"
  Write-Host "BOX_PROVIDER           = $BOX_PROVIDER"
  Write-Host "BOX_FILE               = $BOX_FILE"
  Write-Host "BOX_DESCRIPTION        = $BOX_DESCRIPTION"
  Write-Host "BOX_SHORTDESCRIPTION   = $BOX_SHORTDESCRIPTION"
  Write-Host "BOX_VERSIONDESCRIPTION = $BOX_VERSIONDESCRIPTION"
  Write-Host "VAGRANT_HOSTNAME       = $VAGRANT_HOSTNAME"

  # check if login user
  vagrant cloud auth login --token $env:PACKER_VAGRANTCLOUD_TOKEN
  if($?) {
    
    # check cloud image
    # vagrant cloud search $IMAGE_NAME --short | Select-String -Pattern 'elegoev/ubuntu-18.04'
    Write-Host "image name = $BOX_NAME"

    # create box
    Write-Host ">>>>> create box"
    vagrant cloud box create --no-private "$BOX_NAMESPACE/$BOX_NAME" `
                             --description "$BOX_DESCRIPTION" `
                             --short-description "$BOX_SHORTDESCRIPTION"

    # create version
    Write-Host ">>>>> create version"
    vagrant cloud version create "$BOX_NAMESPACE/$BOX_NAME" $BOX_VERSION --description "$BOX_VERSIONDESCRIPTION"

    # create provider
    Write-Host ">>>>> create provider"
    vagrant cloud provider create "$BOX_NAMESPACE/$BOX_NAME" $BOX_PROVIDER $BOX_VERSION

    # get upload url
    Write-Host ">>>>> get upload url"
    $CURL_RESPONSE = curl --header "Authorization: Bearer $env:PACKER_VAGRANTCLOUD_TOKEN" `
                          https://$VAGRANT_HOSTNAME/api/v1/box/$BOX_NAMESPACE/$BOX_NAME/version/$BOX_VERSION/provider/$BOX_PROVIDER/upload

    # upload box
    $UPLOADURL = $CURL_RESPONSE | jq -r '.upload_path'
    # Write-Host ">>>>> upload url = $UPLOADURL"
    Write-Host ">>>>> upload file" 
    curl $UPLOADURL --request PUT --upload-file $BOX_FILE 
 
    # release box
    Write-Host ">>>>> release upload"
    curl -X PUT --header "Authorization: Bearer $env:PACKER_VAGRANTCLOUD_TOKEN" `
                https://$VAGRANT_HOSTNAME/api/v1/box/$BOX_NAMESPACE/$BOX_NAME/version/$BOX_VERSION/release

  } else {
    Write-Host "Wrong vagrant cloud token configured" -ForegroundColor Red
  }

}





