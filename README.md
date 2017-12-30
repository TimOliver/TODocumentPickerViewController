# TODocumentPickerViewController

<p align="center">
<img src="https://raw.githubusercontent.com/TimOliver/TODocumentPickerViewController/master/screenshot.jpg"/>
</p>

[![Beerpay](https://beerpay.io/TimOliver/TODocumentPickerViewController/badge.svg?style=flat)](https://beerpay.io/TimOliver/TODocumentPickerViewController)
[![PayPal](https://img.shields.io/badge/paypal-donate-blue.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=M4RKULAVKV7K8)

`TODocumentPickerViewController`  is an open source `UIViewController` framework that takes a list of files as input, and displays a navigable file system on iOS devices.

The goal of this project is to provide a completely generic, modular frontend UI for a variety of file services, both online, and locally. With services like Dropbox and Google Drive exposing their file systems via a REST API, and more low-level protocols like SMB and FTP requiring direct object serialisation, `TODocumentPickerViewController` is being engineered in such a way that any file source can be integrated.

# Features
* Uses a delegate / data source model in order to integrate with any file source.
* Can be configured using a configuration object passed to it upon init.
* Self-replicates as users drill down folders, keeping configuration consistent between copies.
* Data source provides an asynchronous mechanism to allow long lasting requests (like REST APIs) to not block the main thread.

## Installation

#### As a CocoaPods Dependency

Add the following to your Podfile:
``` ruby
pod 'TODocumentPickerViewController'
```

#### Manual Installation

All of the necessary source files are in `TODocumentPickerViewController`. Simply copy that folder to your app project folder, and then import it into Xcode.

`TODocumentPickerViewController` also relies on the following libraries:

* [`TOSearchBar`](https://github.com/TimOliver/TOSearchBar)

While copies have been placed in this repo to minimise the need to download multiple other repos, be sure to check to see if there have been updates on their main repos.

## Technical Requirements
iOS 9.0 or above.

## License
TODocumentPickerViewControlleris licensed under the MIT License. Please see the LICENSE file for more information. ![analytics](https://ga-beacon.appspot.com/UA-5643664-16/TODocumentPickerViewController/README.md?pixel)
