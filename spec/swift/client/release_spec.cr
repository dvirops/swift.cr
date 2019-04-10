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

  describe "#rollback_release" do
    it "should do a rollback and return release" do
      stub_get("/tiller/v2/releases/name/rollback/json", "rollback")
      rollback_release = client.rollback_release("name")

      rollback_release.should be_a JSON::Any
      rollback_release["release"]["name"].as_s.should eq "string"
      (rollback_release["release"]["version"].as_i >= 0).should eq true
    end

    it "should do a rollback and return release with dry_run and force params" do
      params = {dry_run: true, force: true}
      stub_get("/tiller/v2/releases/name/rollback/json", "rollback", params: params)
      rollback_release = client.rollback_release("name", params: params)

      rollback_release.should be_a JSON::Any
      rollback_release["release"]["name"].as_s.should eq "string"
      (rollback_release["release"]["version"].as_i >= 0).should eq true
    end

    it "should do a rollback and return release with timeout and recreate params" do
      params = {timeout: 1000, recreate: true}
      stub_get("/tiller/v2/releases/name/rollback/json", "rollback", params: params)
      rollback_release = client.rollback_release("name", params: params)

      rollback_release.should be_a JSON::Any
      rollback_release["release"]["name"].as_s.should eq "string"
      (rollback_release["release"]["version"].as_i >= 0).should eq true
    end
  end

  describe "#install_release" do
    it "should install and return release with some params" do
      form = {
        chart_url: "https://github.com/tamalsaha/test-chart/raw/master/test-chart-0.1.0.tgz",
        namespace: "kube-system",
        values:    {"raw" => "{ \"proxy\": { \"secretToken\": \"mytoken\" }, \"rbac\": { \"enabled\": false}}"},
      }
      stub_post("/tiller/v2/releases/name/json", "install", form: form)
      install_release = client.install_release("name", form: form)

      install_release.should be_a JSON::Any
      install_release["release"]["name"].as_s.should eq "string"
      (install_release["release"]["version"].as_i >= 0).should eq true
    end

    it "should install and return release with chart from helm repo" do
      form = {
        chart_url: "stable/fluent-bit",
      }
      stub_post("/tiller/v2/releases/name/json", "install", form: form)
      install_release = client.install_release("name", form: form)

      install_release.should be_a JSON::Any
      install_release["release"]["name"].as_s.should eq "string"
      (install_release["release"]["version"].as_i >= 0).should eq true
    end
  end

  describe "#update_release" do
    it "should update and return release with some params" do
      form = {
        chart_url: "https://github.com/tamalsaha/test-chart/raw/master/test-chart-0.1.0.tgz",
        namespace: "kube-system",
        values:    {"raw" => "{ \"proxy\": { \"secretToken\": \"mytoken\" }, \"rbac\": { \"enabled\": false}}"},
      }
      stub_put("/tiller/v2/releases/name/json", "update", form: form)
      update_release = client.update_release("name", form: form)

      update_release.should be_a JSON::Any
      update_release["release"]["name"].as_s.should eq "string"
      (update_release["release"]["version"].as_i >= 0).should eq true
    end

    it "should update and return release with chart from helm repo" do
      form = {
        chart_url: "stable/fluent-bit",
      }
      stub_put("/tiller/v2/releases/name/json", "update", form: form)
      update_release = client.update_release("name", form: form)

      update_release.should be_a JSON::Any
      update_release["release"]["name"].as_s.should eq "string"
      (update_release["release"]["version"].as_i >= 0).should eq true
    end
  end

  describe "#uninstall_release" do
    it "should delete the named release" do
      stub_delete("/tiller/v2/releases/name/json", "delete")
      uninstall_release = client.uninstall_release("name")

      uninstall_release.should be_a JSON::Any
      uninstall_release["release"]["name"].as_s.should eq "string"
      (uninstall_release["release"]["version"].as_i >= 0).should eq true
    end

    it "should delete the named release with params" do
      form = {purge: true, disable_hooks: true, timeout: 100}
      stub_delete("/tiller/v2/releases/name/json", "delete", form: form)
      uninstall_release = client.uninstall_release("name", form: form)

      uninstall_release.should be_a JSON::Any
      uninstall_release["release"]["name"].as_s.should eq "string"
      (uninstall_release["release"]["version"].as_i >= 0).should eq true
    end
  end
end
