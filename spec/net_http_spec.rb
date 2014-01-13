require 'spec_helper'

describe Net::HTTP do
  describe :post_form_with_ssl do
    it "should SSL verify" do
      lambda {
        result = Net::HTTP.post_form_with_ssl URI.parse('https://www.fusemail.com/api/request.html'), {}
        result.class.should == Net::HTTPOK
      }.should_not raise_exception
    end

    it "should reject SSL mismatches" do
      lambda {
        Net::HTTP.post_form_with_ssl URI.parse('https://67.207.202.119/'), {}
      }.should raise_exception(OpenSSL::SSL::SSLError, /hostname/)
    end
  end
end
