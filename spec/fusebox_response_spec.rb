require 'spec_helper'

describe Fusebox::Response do
  it "should instantiate" do
    mocked_httpok = mock('Net::HTTPOK')
    mocked_httpok.stub!(:body).and_return('1||Success')
    resp = Fusebox::Response.new(mocked_httpok)
    resp.success?.should == true
    resp.detail.should == 'Success'
    resp.code.should == 1
  end
  
  it "should populate records" do
    mocked_httpok = mock('Net::HTTPOK')
    mocked_httpok.stub!(:body).and_return("1||Success \n\"test@example.com\",\"302953\",\"Alias\",\"test-*@example.com\",\"\"\n\"test@example.com\",\"302953\",\"Alias\",\"admin@example.com\",\"\"\n\"test@example.com\",\"302953\",\"Alias\",\"test@example.com\",\"\"\n")
    resp = Fusebox::Response.new(mocked_httpok, :reportmail)
    resp.records.should be_a(Array)
    resp.records.length.should == 3
    resp.records.first.should be_a(Hash)
    resp.records.first[:username].should == 'test@example.com'
  end
end