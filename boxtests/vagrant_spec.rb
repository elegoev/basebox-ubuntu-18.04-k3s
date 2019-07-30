# Test Vagrant Image
describe 'Vagrant Image Tests' do
  describe user('vagrant') do
    it { should exist }
    it { should belong_to_group 'vagrant' }
  end
end
