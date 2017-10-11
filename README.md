# iOS InApp Settings TableView from Settings bundle
I wanted to create a <b>TableView</b> which is automatically generated from the <b>Settings.bundle</b>. There used to be a framework InAppSettings but this isn't working with iOS 7 and up. So I decided to write my own code to achieve this.

This framework will generate a TableView with your settings data exactly like in the Settings tab generated in your Preferences app.

## Overview
* [Features](#features)
* [Implementation](#implementation)
* [Donation](#donate)
* [License](#license)
* [Warranty](#warranty)

## Features
- It supports the setting types *Title*, *Group*, *Text Field*, *Multi Value* and *Toggle Switch*.
- It does NOT SUPPORT *Slider*.
- This solution supports *portrait* AND *landscape* mode and can also handle *changing device orientations*.

## Implementation
First off all I'm assuming that you are using the following code to read out your default values from the Settings.bundle.
https://github.com/KingIsulgard/iOS-InApp-Settings-TableView/blob/master/registerSettingsFromBundle.m

It's best to call this function in your **AppDelegate** in the function **applicationWillEnterForeground**. 

You will need to include the 2 classes **SettingsTableViewController** and **MultiValueTableViewController** in your project (both .h and .m files of course), which can also be found in this folder.

**Storyboard** Now go the storyboard and create a **TableViewController**. Select the TableViewController and Choose **Editor** -> **Embed in** -> **Navigation controller**.

Set the class of the TableViewController as **SettingsTableViewController**. Set the identifier of the cell as "*Cell*", add a second TableViewCell to the TableView and set it's identifier as "*MultiValueCell*". Add a second TableViewController, and CTRL+CLICK and drag from the MultiValueCell to the second TableViewController. Set the class of the second TableViewController as **MultiValueTableViewController**. Set the identifier of the cell in the second TableViewController as "*Cell*" too. That's it!

## Donate
You can support [contributors](https://github.com/KingIsulgard/iOS-InApp-Settings-TableView/graphs/contributors) of this project individually. Every contributor is welcomed to add his/her line below with any content. Ordering shall be alphabetically by GitHub username.

Please consider a small donation if you use iOS-InApp-Settings-TableView in your projects. It would make me really happy.

* [@KingIsulgard](https://github.com/KingIsulgard): <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HQE64D8RQGPLC"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif" alt="[paypal]" /></a> !

## License
The license for the code is included with the project; it's basically a BSD license with attribution.

You're welcome to use it in commercial, closed-source, open source, free or any other kind of software, as long as you credit me appropriately.

## Warranty
The code comes with no warranty of any kind. I hope it'll be useful to you (it certainly is to me), but I make no guarantees regarding its functionality or otherwise.
