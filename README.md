## Welcome to codeclimate_service

This is a microservice to works with Github pull requests and codeclimate-cli.

Always when a pull request is open or update with commits, this this webservice will be called by GitHub and process new instance of codeclimate-cli up on docker.

## Getting Started

From source code:

```
git clone git@github.com:vgsantoniazzi/codeclimate_service.git
cd codeclimate_service
mix deps.get, compile
mix test
mix server
```

## Usage

Configure you repository at GitHub to always send a http request to `/webhook`.

Open a new pull request and see this sevice running and beeing a check to merge a new PR.

## Contributing

I :heart: Open source!

[Follow github guides for forking a project](https://guides.github.com/activities/forking/)

[Follow github guides for contributing open source](https://guides.github.com/activities/contributing-to-open-source/#contributing)

## Code status

[![Build Status](https://travis-ci.org/vgsantoniazzi/codeclimate_service.svg?branch=master)](https://travis-ci.org/vgsantoniazzi/codeclimate_service)

## License

codeclimate_service is released under the [MIT license](http://opensource.org/licenses/MIT).
