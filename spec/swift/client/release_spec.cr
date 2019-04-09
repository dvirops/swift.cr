require "../../spec_helper"

describe Swift::Client::Release do
  describe "#releases" do
    it "should return a list of all releases" do
      stub_get("/tiller/v2/releases/json", "releases")
      releases = client.releases

      releases.should be_a JSON::Any
      releases["releases"].is_a? Array
      releases["next"].is_a? String
      (releases["total"].as_i >= 0).should eq true
      (releases["count"].as_i >= 0).should eq true
      (releases["releases"].size > 0).should eq true
    end

    it "should return an empty json data of releases" do
      stub_get("/tiller/v2/releases/json")
      releases = client.releases

      releases.should be_a JSON::Any
      releases["releases"].is_a? Array
      releases["next"].is_a? String
      (releases["total"].as_i >= 0).should eq true
      (releases["count"].as_i >= 0).should eq true
      (releases["releases"].size > 0).should eq true
    end
  end

  describe "#release_status" do
    it "should return status information for the specified release" do
      stub_get("/tiller/v2/releases/name/status/json", "status")
      release_status = client.release_status("name")

      release_status.should be_a JSON::Any
      release_status["name"].as_s.should eq "string"
      release_status["namespace"].as_s.should eq "string"
      release_status["info"]["status"]["code"].as_s.should eq "UNKNOWN"
    end
  end

  describe "#release_content" do
    it "should return the release content (chart + value) for the specified release" do
      stub_get("/tiller/v2/releases/name/content/json", "content")
      release_content = client.release_content("name")

      release_content.should be_a JSON::Any
      release_content["release"]["name"].as_s.should eq "string"
      (release_content["release"]["version"].as_i >= 0).should eq true
    end
  end

  describe "#release_history" do
    it "should return the release content (chart + value) for the specified release" do
      stub_get("/tiller/v2/releases/name/json", "history")
      release_history = client.release_history("name")

      release_history.should be_a JSON::Any
      release_history["releases"][0]["name"].as_s.should eq "string"
      (release_history["releases"][0]["version"].as_i >= 0).should eq true
    end

    it "should return the release content (chart + value) for the specified release with max variable" do
      params = {max: 10}
      stub_get("/tiller/v2/releases/name/json", "history", params: params)
      release_history = client.release_history("name", params: params)

      release_history.should be_a JSON::Any
      release_history["releases"][0]["name"].as_s.should eq "string"
      (release_history["releases"][0]["version"].as_i >= 0).should eq true
    end
  end

  # describe "#rollback_release" do
  #   it "should return the release content (chart + value) for the specified release" do
  #     stub_get("/tiller/v2/releases/name/json", "history")
  #     rollback_release = client.rollback_release("name", params: {dry_run: true, force: true})

  #     rollback_release.should be_a JSON::Any
  #     rollback_release["releases"][0]["name"].as_s.should eq "string"
  #     (rollback_release["releases"][0]["version"].as_i >= 0).should eq true
  #   end
  # end
end
