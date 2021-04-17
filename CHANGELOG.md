# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- fixed empty home-assistant version string in `org.opencontainers.image.title` label
- `docker-compose`: fix support for home-assistant images `>=2021.4.0` by mounting `tmpfs` for `async_dns`
  (fixes: `PermissionError: [Errno 13] Permission denied: '/home/hass/.config/async_dns'`)

## [1.1.0] - 2021-04-17
### Added
- image labels:
  - `org.opencontainers.image.revision` (git commit hash via build arg)
  - `org.opencontainers.image.source` (repo url)
  - `org.opencontainers.image.title`
- set env var `MPLCONFIGDIR=/config/matplotlib`
- `docker-compose`: added CPU & memory limit

### Fixed
- `docker-compose`: drop capabilities

## [1.0.2] - 2020-05-03
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

[Unreleased]: https://github.com/fphammerle/docker-home-assistant/compare/v1.1.0...master
[1.1.0]: https://github.com/fphammerle/docker-home-assistant/compare/v1.0.2...v1.1.0
[1.0.2]: https://github.com/fphammerle/docker-home-assistant/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/fphammerle/docker-home-assistant/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/fphammerle/docker-home-assistant/tree/v1.0.0
