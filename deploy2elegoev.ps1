## deploy vagrant box to vagrant cloud
#

# prepare environment
#
#         vagrant cloud auth login elegoev
#

vag-bp -custboxname "ubuntu-18.04-k3s" `
       -targetns "elegoev" `
       -targetrepo vagrantcloud `
       -boxdesc "vagrant basebox with ubuntu 18.04 & k3s" `
       -versiondesc "initial version"
