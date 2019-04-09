require "../spec_helper"

describe Swift::Client do
  describe ".initialize" do
    it "should initialize client" do
      Swift::Client.new(SWIFT_ENDPOINT, SWIFT_USERNAME, SWIFT_PASSWORD).should be_a Swift::Client
    end
  end

  # describe ".available?" do
  #   it "should return true if service works" do
  #     stub_get("/health", "health")
  #     client.available?.should be_true
  #   end
  # end
end
