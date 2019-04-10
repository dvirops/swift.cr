# Swift.cr

[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://devops-israel.github.io/swift.cr/)
[![GitHub release](https://img.shields.io/github/release/devops-israel/swift.cr.svg)](https://github.com/devops-israel/swift.cr/releases)
[![Build Status](https://travis-ci.org/devops-israel/swift.cr.svg?branch=master)](https://travis-ci.org/devops-israel/swift.cr)


[swift.cr](https://github.com/devops-israel/swift.cr) is a [Swift API](https://appscode.com/products/swift/) wrapper writes with [Crystal](http://crystal-lang.org/) Language.

Inspired from [gitlab](https://github.com/icyleaf/gitlab.cr).

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  swift:
    github: devops-israel/swift.cr
```

2. Run `shards install`

## Usage

```crystal
require "swift"

# configuration
endpoint = "https://charts.example.com" # No tailing forward slash
username = "<username>"
password = "<password>"

# initialize a new client with user and password for basic auth
swift_client = Swift.client(endpoint, username, password)
# => #<Swift::Client:0x101653f20 @endpoint="https://charts.example.com", @username="xxx", @password="xxx>

# server health
swift_client.available?
# true
```

## Implemented API

#### Completed

##### Chart Manipulation
- `GET /tiller/v2/releases/json` - List releases
- `GET /tiller/v2/releases/[name]/status/json` - list release status
- `GET /tiller/v2/releases/[name]/content/json` - list release content
- `GET /tiller/v2/releases/[name]/json` - list release history
- `GET /tiller/v2/releases/[name]/rollback/json` - rollback a release
- `POST /tiller/v2/releases/[name]/json` - install a new release
- `PUT /tiller/v2/releases/[name]/json` - upgrade a new release
- `DELETE /tiller/v2/releases/[name]/json` - delete a release

### Server Info
- `GET /tiller/v2/version/json` - returns 200 OK

## Development

### Prerequisites

* [Docker](https://www.docker.com/products/docker-desktop)

### Commands

* From inside the root of the project run `docker-compose up`
* The container is configured to run tests every time a file is changed so just start developing.

## Contributing

1. Fork it (https://github.com/devops-israel/swift.cr/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Josh Dvir](https://github.com/joshdvir) - creator and maintainer

## License

[MIT License](https://github.com/devops-israel/swift.cr/blob/master/LICENSE) © devops-israel