# Recycle Can iOS
Recycle Can is an iOS application that facilitates recycling of electronics, batteries, and paint for Canadians. Making use of Mapkit and geocoding, Recycle Can provides both a navigational toolset as well as a massive database to help users recycle their electronic waste. This is the iOS version with the full and much more functionality of the Recycle Can website. To run the application, it can be found on the iOS app store. Otherwise, manual installation can be done through this repository with a few simple steps

# Links

1. [Requirements](#requirements)
2. [Setup](#setup)
   * [Download](#download)
   * [Installation](#installation)
3. [Features](#features)<br />
   * [Navigation Routes](#navigation-routes)
   * [Toolbar](#toolbar)<br />
4. [Database Files](#database-files)
5. [License](#license)
6. [Contact](#contact)


# Requirements
Recycle Can will work with any iOS device running iOS 9.0 or above. It is highly recommended for users to enable location services in-app to facilitate our navigational tools. Otherwise, the application is still fully functional but lacks features such as automatic routing from the current location to a desired destination. Without location services, the default location is set at Ottawa, Ontario.

# Setup
Recycle Can can be installed manually or on the app store. The way to manually install this iOS application is detailed below

## Download
Find the Recycle_Can.ipa file in the main directory and download it. This can be done by doing

```
$ git clone https://github.com/EdwaRen/Recycle_Can_iOS
```
The Recycle_Can.ipa file is the only important file needed for installation, the rest are production files that contain the open sourced code.

## Installation
Next, drag the .ipa file into iTunes with your iDevice connected.

# Features

## Navigation Routes
Recycle Can provides tools to help navigate to the nearest recycling location. By detecting your location and comparing it with a massive database of recycling centers, Recycle Can calculates the optimal location for your specific needs. Furthermore, the most efficient route to the destination is also plotted in-app that can be followed in real-time. This functionality makes it unnecessary to exit the app, as previous versions would open up Apple's 'Maps' application to plot the route there.

The closest recycling locations are automatically displayed on the screen. Plotting a route can be simply achieved by clicking on a location (marked by a pin) and clicking the car button to the left of the popup annotation view. On the bottom right of the screen, additional information such as distance to that location is also shown.

## Toolbar
A toolbar at the bottom of the screen provides helpful buttons to optimize the user experience. These include zooming to the original location, deselecting routes, or showing a minimalist screen with less buttons.

# Database Files
The databases (in MS Excel) has been linked below. Since the file size is 'relatively' small, it has been decided to simply store it locally rather than a server-side database. This is to avoid potential complications with server down-times and the fact that recycling locations are rather static which do not need constant updates. All the locations have been found in publicly available sources. If there are any inconsistencies or missing locations, please feel free to contact us to express these concerns.

https://drive.google.com/open?id=0B-e2EwA68EQgNnB2cWxOcWp3cjQ

# License
Copyright Edward Ren 2017
MIT License see [LICENSE](../blob/master/LICENSE)

# Contact
If you have any questions or inquiries concerning Recycle Can or suggestions for future releases, send an email to Edward.ren.2013@gmail.com
