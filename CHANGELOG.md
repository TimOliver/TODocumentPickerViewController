# CHANGELOG
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## Unreleased

## 0.2.1 - 2017-12-30

### Fixed
- Table header view not being properly obscured under the navigation bar on iPhone X.
- Properly aligned the text label in the toolbar at the bottom.

## 0.2.0 - 2017-12-30

### Added
- New icon design to align with iOS 11's new overall feel.
- A system to automatically generate icons for specific file formats.

### Changed
- Changed theme settings from `NSDictionary` to a dedicated object with properties.
- Removed the alphabetical sectioning of the files list in favour of integrating `TOSearchBar` in a later release.

### Fixed
- Fixed scrolling inset bugs introduced due to iOS 11.
- Fixed header view insetting behaviour to be more consistent, especially when the refresh control is visible.

