# copyright: 2021, Urs Voegele

title "check standard vagrant user"

# check standard user
control "user-1.0" do                       # A unique ID for this control
  impact 1.0                                # The criticality, if this control fails.
  title "check if vagrant user exists"      # A human-readable title
  desc "check vagrant user"
  describe user("vagrant") do               # The actual test
    it { should exist }
  end
end
