# File Browser Flutter

This app is a client for the [File Browser server service](https://github.com/filebrowser/filebrowser/). This app has been tested with version [] of the server.

## Features

These are the feature of this client available at the moment:
* login/logout with user credentials
* navigation through all folders and files of the user account.
* Drag down to refresh folder if user want to force a refresh of a folder.
* download of files (1 at a time) to local disk of the device
* upload of files (1 at a time) from local disk to the remote folder in view.
* delete remote files (1 at a time).
* rename a remote file (name with or without extension).
* multi-language support** (it - en).

** : additional languages could be imported. If you want to translate the app to other languages, then download this [RAW file](./lib/I18n/app_en.arb) and create a copy on your PC. Call it ```app_$language$>.arb``` where ```$language$``` will be the short representation of the language and edit all content inside. Keep all the keys the same but change the value corresponding (this file is like a JSON file so it must be edited in pretty the same way).

## Platform

This app has been developed using the Flutter Framework and therefore is available on more devices. At the moment of writing this README the app has been tested and works on these type of devices:
* Windows 11** [x64 bit]
* Android***

**: not tested on Windows 10 or order version. You could try and see if it works.<br>
***: version 10 and 13 tested but should work with Android version 7 and up.

## Usage

In order to use the app you first of all have an instance of File Browser server up and running somewhere (home lab or in the cloud) then you have to grab the version of your O.S. selecting the latest [release](https://github.com/EugenioGandini/FileBrowserFlutter/releases).
After that depending on the O.S. you have to:
* <strong>On Windows</strong>: extract the content of the compressed archive somewhere in your disk (e.g.: create a folder in ```C:\Users\<username>\filebrowserclient```). Then launch the executable file that you find inside the folder (hint: you can create a Desktop shortcut to access easily the app without navigating all the time to this folder).
* <strong>On Android</strong>: copy the downloaded APK file to your device and install it using a file browser (you should grant allow app to be installed from unknown location in Android settings).

## Libraries used

For a up to date list of libraries you should check the [pubspec.yaml](./pubspec.yaml) file in the root of this project.

## Credits

* Developers and maintainers of [Flutter SDK](https://flutter.dev/) for the use of the framework and [Dark lang](https://dart.dev/) on which is based.
* All contributors of [Freezed library](https://github.com/rrousselGit/freezed) for this useful library.
* dash-overflow.net for packages such as [provider](https://pub.dev/packages/provider).
* dart-team for the intl package.
[]

## Author

* [Eugenio Gandini](https://github.com/EugenioGandini)