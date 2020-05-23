Copy Screenshots v1.1.0.4

Please note that this will likely break in future version of the console. and to use at your own risk.

Usage:
* `Plugin "Copy Screenshots"`
* Will any screen shots (with the name *display*.png) to all connected USB sticks
  in the folder grandMA3\shared\resource\lib_images

![Example Image](https://github.com/hossimo/GMA3Plugins/blob/master/Images/CopyScreenshots.png)

Issues:
* The console currently enumerates all disk connected to the console including 
  pervious versions (?) This may cause some skipped files even with the USB key
  dot not include the selected file
* The copied files are not checked for consistency, this could be done but did
  not seem necessary
* If a file exists on a key with the exact name the fill will be skipped and noted
  in the System Monitor
* if the key does not have the grandMA3 folder structure the copy will fail and all
  files will be skipped. Store a show to the stick first.

Releases:
* 1.0.0.1 - Initial release
* 1.0.0.2 - Fixed a path parsing bug causing the plugin to not work on the console.
* 1.0.0.3 - Making functions local

