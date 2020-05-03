# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- fix container startup for home assistant `>=0.107.0`
  by replacing [s6-overlay](https://github.com/home-assistant/docker-base/pull/62) entrypoint with `tini`

## [1.0.1] - 2020-02-02
### Fixed
- configure `pip` to install to user's home dir
  (fixes `EnvironmentError: [Errno 13] Permission denied …` on `pip install`)
- added `gcc` to be able install python packages
  that are only available as sdist
  (e.g., Adafruit-DHT)

## [1.0.0] - 2020-02-01
### Added
- docker-compose: mount config volume

### Changed
- wrap official docker image

### Fixed
- docker-compose: forward correct default port `8123`

[Unreleased]: https://github.com/fphammerle/docker-home-assistant/compare/v1.0.1...master
[1.0.1]: https://github.com/fphammerle/docker-home-assistant/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/fphammerle/docker-home-assistant/releases/tag/v1.0.0
