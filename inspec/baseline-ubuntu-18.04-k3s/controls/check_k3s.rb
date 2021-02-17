# copyright: 2021, Urs Voegele

title "check k3s"

# check k3s command
control "k3s-1.0" do                        # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "check if k3s command exists"       # A human-readable title
  desc "check k3s command"
  describe command('k3s --version') do
    its('exit_status') { should eq 0 }
  end
end
