# Receipt Scanner

A mobile application for scanning receipts and storing financial data.

Last Updated: June 30, 2019

## Quick Start

Regardless of whether this is your first time working with a mobile application from a repository, your first time working with the receipt scanner application, or if you are a returning viewer or user of the receipt scanner application, start here if you want to run the application on an android device.

### 1. Download the APK

Choose which release and version you would like to install for the receipt scanner application. We recommend grabbing the latest [release](https://github.com/chandlerbrtek/receiptscanner/releases). 

### 2. Prepare your Android device

There are two types of Android devices you can use. You can plug your phone into your computer and move the APK onto the phone, or you can use an emulator. If you decide to use an emulator, you'll want to use [Android Studio](https://developer.android.com/studio) to create and start one. Once you have one running, move the APK onto the emulator.

### 3. Install the applicaiton from the APK

Installing the application from the APK is incredibly simple. Just find the APK on the device's file system, then tap and select install. If play protect warns you about the app, choose to install anyway. There's no way to avoid this issue. If play protect doesn't warn you and the application fails to install, you'll need to disable play protect to install the application. Once installed, we recommend re-enabling play protect settings on the play store.

### 4. Run the application!

Now that you've installed the application, just find it in the app drawer or search for it on the device and tap it to run. Congratulations, you can now use the receipt scanner appliation!

## Project Information

The receipt scanner application is the result of a group project course. The goal of the project is to create an application which scans receipts from images to generate financial data insights for the user.

### Course Information

Course Number - CSCI4830

Course Name - Software Engineering

University - University of Nebraska Omaha

Instructor - Harvey Siy

### Team Members

Joseph Ralston - Project Manager and Developer

Luke Moorhous - Software Architect and Developer

Chandler Brtek - Lead QA Engineer and Developer

Savon Philips - Lead Support Engineer and Developer

## Releases

### Milestone 1

Monday, June 24, 2019

In Milestone 1 the Receipt Scanner Application team is happy to release the initial state of the applicaiton's user interface and user experience flows as well as the initial database definitions and integrations. The application stores receipts and supports flows for reports, but scanning from a photo and generating dynamic reports have not yet been implemented. See the links below to view or download the application.


View the [release](https://github.com/chandlerbrtek/receiptscanner/releases/tag/milestone_1)

View the [demo](https://youtu.be/Djsdb5ymcoo)

#### Release Notes

[Issue #4](https://github.com/chandlerbrtek/receiptscanner/issues/4) - Created a Receipt class to store receipts and their properties in memory.

[Issue #6](https://github.com/chandlerbrtek/receiptscanner/issues/6) - Added an application home page with a navigation drawer to navigate to the application’s stored data.

[Issue #8](https://github.com/chandlerbrtek/receiptscanner/issues/8) - Created a Receipt database table using Flutter’s [sqflite](https://pub.dev/packages/sqflite) plugin to store receipts on the user’s device.

[Issue #9](https://github.com/chandlerbrtek/receiptscanner/issues/9) - Created flyout bar (drawer) with selectable options for reports. Expanded placeholder for budgeting feature if we have time to implement this in Milestone 3

[Issue #10](https://github.com/chandlerbrtek/receiptscanner/issues/10) - Added a modal to the main page that allows the user to select whether they want to add receipt data via a picture, a saved image or via manual entry.

[Issue #11](https://github.com/chandlerbrtek/receiptscanner/issues/11) & [Issue #19](https://github.com/chandlerbrtek/receiptscanner/issues/19) - Added accessible pages for different reports. Reports are being fully implemented in Milestone 2.

[Issue #12](https://github.com/chandlerbrtek/receiptscanner/issues/12) - Implemented Flutter’s [image_picker](https://pub.dev/packages/image_picker) plugin to allow the application to use the device’s native camera functionality.

[Issue #13](https://github.com/chandlerbrtek/receiptscanner/issues/13) - Added a database API for use within the application. This allows for the application to interact with its database in an orderly and consistent way.

[Issue #14](https://github.com/chandlerbrtek/receiptscanner/issues/14) - Added the manual entry page, which allows the user to enter a total and date from their receipt and then submit that to the database.

[Issue #15](https://github.com/chandlerbrtek/receiptscanner/issues/15) - Implemented Flutter’s [image_picker](https://pub.dev/packages/image_picker) plugin to allow the application to use the device’s native gallery functionality.

## Resources Used

[Navigation Drawer](https://medium.com/flutterpub/navigation-drawer-using-flutter-cc8a5cfcab90)

[Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)

[Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

[Online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
