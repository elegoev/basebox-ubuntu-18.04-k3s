# copyright: 2020, Urs Voegele

title "check docker"

# check docker package
control "docker-1.0" do                     # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "check if docker is installed"      # A human-readable title
  desc "check docker package"
  describe packages(/docker/) do           # The actual test
    its('statuses') { should cmp 'installed' } 
  end
end

# check docker service
control "docker-2.0" do                     # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "check if docker is running"        # A human-readable title
  desc "check docker service"
  describe service('docker') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
