require 'spec_helper'

describe Fusebox::Request do
  it "should instantiate" do
    @request = Fusebox::Request.new
  end
  
  Fusebox::Request::COMMANDS.each do |command|
    describe command do
      it "should call post" do
        request = Fusebox::Request.new('user', 'pass')
        request.should_receive(:post).and_return(nil)
        request.send(command, {})
      end
    end
  end  
  
  describe 'convert_post_vars' do
    it "should convert booleans to 'yes' 'no' strings" do
      post_vars = Fusebox::Request.convert_post_vars({ 'positive' => true, 'negative' => false })
      post_vars['positive'].should == 'yes'
      post_vars['negative'].should == 'no'
    end
    
    it "should convert arrays" do
      post_vars = Fusebox::Request.convert_post_vars({ 'my_array' => %w(ichi ni san) })
      post_vars.values.length.should == 3
      post_vars.keys.should_not include('my_array')
      post_vars['my_array[0]'].should == 'ichi'
      post_vars['my_array[1]'].should == 'ni'
      post_vars['my_array[2]'].should == 'san'
    end
  end
  
  describe 'post' do
    it "should" do
      mocked_httpok = mock('Net::HTTPOK')
      mocked_httpok.stub!(:body).and_return('1||Success')
      
    end
  end
  
  context "authentication" do
    it "should load authentication from yaml" do
      Fusebox::Request.auth_yaml_paths = [File.join(File.dirname(__FILE__), 'fixtures', 'fusemail.yaml')]
      req = Fusebox::Request.new
      req.username.should == 'my_yaml_username'
      req.password.should == 'my_yaml_password'
    end
  
    it "should not load yaml when a username and password are provided" do
      req = Fusebox::Request.new('my_inst_username', 'my_inst_password')
      req.username.should == 'my_inst_username'
      req.password.should == 'my_inst_password'
    end
  end
  
end