require "./spec_helper"

describe Swift do
  context ".client" do
    it "should be a Swift::Client" do
      Swift.client("string").should be_a Swift::Client
    end

    it "should not override each other" do
      client1 = Swift.client("https://swift1.example.com")
      client2 = Swift.client("https://swift2.example.com")
      client1.endpoint.should eq "https://swift1.example.com"
      client2.endpoint.should eq "https://swift2.example.com"
    end

    it "should set username and password when provided" do
      client = Swift.client("https://swift2.example.com", "username", "password")
      client.endpoint.should eq "https://swift2.example.com"
      client.username.should eq "username"
      client.password.should eq "password"
    end
  end
end
