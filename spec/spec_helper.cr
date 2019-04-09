require "spec"
require "webmock"
require "../src/swift"

SWIFT_ENDPOINT = "https://swift.example.com"
SWIFT_USERNAME = "username"
SWIFT_PASSWORD = "password"

def client
  Swift.client(SWIFT_ENDPOINT, SWIFT_USERNAME, SWIFT_PASSWORD)
end

def load_fixture(name : String?)
  return "" unless name
  File.read_lines(File.dirname(__FILE__) + "/fixtures/#{name}.json").join("\n")
end

# GET
def stub_get(path, fixture, params = nil, response_headers = {} of String => String, status = 200)
  query = "?#{HTTP::Params.encode(params)}" if params

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:get, "#{client.endpoint}#{path}#{query}")
    .with(headers: {"Authorization" => "Basic " + Base64.encode(client.username.to_s + ":" + client.password.to_s).chomp})
    .to_return(status: status, body: load_fixture(fixture), headers: response_headers)
end

# POST
def stub_post(path, fixture, status_code = 200, params = nil, form = nil, response_headers = {} of String => String)
  query = "?#{HTTP::Params.escape(params)}" if params
  body = HTTP::Params.encode(form) if form

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:post, "#{client.endpoint}#{path}#{query}")
    .with(body: body, headers: {"Authorization" => "Basic " + Base64.encode(client.username.to_s + ":" + client.password.to_s).chomp})
    .to_return(body: load_fixture(fixture), headers: response_headers, status: status_code)
end

# PUT
def stub_put(path, fixture, form = nil, response_headers = {} of String => String)
  body = HTTP::Params.encode(form) if form

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:put, "#{client.endpoint}#{path}")
    .with(body: body, headers: {"Authorization" => "Basic " + Base64.encode(client.username.to_s + ":" + client.password.to_s).chomp})
    .to_return(body: load_fixture(fixture), headers: response_headers)
end

# DELETE
def stub_delete(path, fixture, form = nil, response_headers = {} of String => String)
  body = HTTP::Params.encode(form) if form

  response_headers.merge!({"Content-Type" => "application/json"})
  WebMock.stub(:delete, "#{client.endpoint}#{path}")
    .with(body: body, headers: {"Authorization" => "Basic " + Base64.encode(client.username.to_s + ":" + client.password.to_s).chomp})
    .to_return(body: load_fixture(fixture), headers: response_headers)
end
