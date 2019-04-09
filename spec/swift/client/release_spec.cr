require "../../spec_helper"

describe Swift::Client::Release do
  # describe ".releases" do
  #   it "should return a json data of charts" do
  #     stub_get("/api/charts", "charts")
  #     charts = client.charts

  #     charts.should be_a JSON::Any
  #     charts["application-1"][0]["name"].as_s.should eq "application-1"
  #     charts["application-1"][0]["version"].as_s.should eq "6410"
  #     charts["application-1"][0]["version"].as_s.should eq "6410"
  #     charts["application-2"][1]["name"].as_s.should eq "application-2"
  #     charts["application-2"][1]["version"].as_s.should eq "6411"
  #     charts["application-2"][1]["version"].as_s.should eq "6411"
  #   end
  # end

  # describe ".release_status" do
  #   it "should return information about a chart" do
  #     stub_get("/api/charts/application-1", "chart")
  #     chart = client.chart("application-1")

  #     chart.should be_a JSON::Any
  #     chart[0]["name"].as_s.should eq "application-1"
  #     chart[0]["version"].as_s.should eq "6410"
  #     chart[0]["version"].as_s.should eq "6410"
  #   end
  # end

  # describe ".release_content" do
  #   it "should return information about a specific version of a chart" do
  #     stub_get("/api/charts/application-1/6412", "version")
  #     chart = client.version("application-1", "6412")

  #     chart.should be_a JSON::Any
  #     chart["name"].as_s.should eq "application-1"
  #     chart["version"].as_s.should eq "6412"
  #     chart["version"].as_s.should eq "6412"
  #   end
  # end
end
