require 'spec_helper'

describe Gitlab::Configuration::Settings do

   before :each do
     @settings = Gitlab::Configuration::Settings.config
   end

  it 'should get settings config' do
    expect(@settings).to be_instance_of(Gitlab::Configuration::Settings)
  end

  it 'should load the config file' do
    allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
    expect(@settings.file_config).to be_instance_of(Hash)
  end

   it 'should throw error config file is bad' do
     allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings_bad.yml'))
     expect{@settings.file_config}.to raise_error
   end

  it 'should prefer endpoint environment variable' do
    ENV['GITLAB_API_ENDPOINT'] = 'http://special.com'
    allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
    expect(@settings.endpoint).to eq('http://special.com')
  end

   it 'should prefer token environment variable' do
     ENV['GITLAB_API_PRIVATE_TOKEN'] = 'some_token'
     allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
     expect(@settings.private_token).to eq('some_token')
   end

   it 'should get endpoint variable' do
     ENV['GITLAB_API_ENDPOINT'] = nil
     allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
     expect(@settings.endpoint).to eq('https://gitlab.com/api/v3')
   end

   it 'should prefer environment variable' do
     ENV['GITLAB_API_PRIVATE_TOKEN'] = nil
     allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
     expect(@settings.private_token).to eq('1234567abcdefg!#JK')
   end

   it 'should retrun a default agent' do
     allow(@settings).to receive(:settings_path).and_return(File.join(fixtures_dir, 'settings.yml'))
     expect(@settings.user_agent).to eq("Gitlab Ruby Gem #{Gitlab::VERSION}")
   end

   it 'should load the secondary config' do
     ENV['GITLAB_CONFIG_FILE'] = 'server_a.yml'
     expect(@settings.config_file).to eq('server_a.yml')
   end
end