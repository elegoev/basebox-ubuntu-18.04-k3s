# copyright: 2021, Urs Voegele

title "check tmp directory"

# check /tmp directory
control "tmp-1.0" do                        # A unique ID for this control
  impact 0.7                                # The criticality, if this control fails.
  title "Create /tmp directory"             # A human-readable title
  desc "Create /tmp directory"
  describe file("/tmp") do                  # The actual test
    it { should be_directory }
  end
end
