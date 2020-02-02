# Caldav Calendar Plugin for Roundcube

**This is my first fork version and will pretty much remain "As Is" except for issue fixes and maintenance.**

I am going to concentrate most of my efforts on a new calendar. I have MAJOR plans for it and want to have a stable LTS version (this Repo) and one I am going add some serious feature enhancements.\
If you are a Computer Nerd like me and enjoy testing buggy, on the edge software, then I suggest you try my experimental calendar, [Texas Edition](https://github.com/texxasrulez/caldav_calendar_te) 

**IMPORTANT** If you are updating this plugin from < 0.5.x to 0.6.x, a clean install is required. Read the [Update Info](update_guide.md) page for details.

**Tested using**
* Roundcube v1.4.2
* Nextcloud v18.0
* PHP v7.2.24
* MySQL Server v5.5.60

**Elastic Skin Support now available**


I forked this with the intent to make a working, out of the box, specific for Nextcloud, caldav enabled calendar to sync your Nextcloud events to a Roundcube Calendar which then can be managed from Roundcube and stay in sync with Nextcloud.

I will update this when needed by deprecated purposes or when Nextcloud changes their sabre version for as long as I can. I am currently dreaming of many other features, but would love some help on that.

This plugin is intended to be used with Nexcloud only at this point in time. The Calendar Plugin will sync already existing calendars from Nextcloud. If you want more than the default, you must add calendar within Nextcloud Calendar GUI and then go back to Roundcube and it will magically appear in your Roundcube Calendar GUI. From Roundcube Calendar GUI, you can add, edit, delete, download, copy and invite participants to your events and will be in sync with Nextcloud. Invitations are succesfully sent, accepted, declined, etc ... 

This is also compatible with RCMCARDDAV 3.0.3 as I use it to sync my contacts with Nextcloud to Roundcube as well.

For Roundcube 1.3 download ver 0.4 here https://github.com/texxasrulez/Caldav_Calendar/releases/tag/0.4

_________________________________________________________________________________________

**Installation**

Installation is pretty straight forward. I wouldn't use composer to install, just download repo from github and follow the directions below:

Copy/FTP/Upload calendar, libcalendaring and libkolab folders to Roundcube Plugin folder, copy config.inc.php.dist to config.inc.php, located in root of calendar directory, and change:
* domain.ltd to your FQDN. These URL's are already configured for the default calendar url for Nextcloud assuming installed in default directory. If Nextcloud was installed using a custom directory, change /nextcloud/ to the directory name you installed in.
* *IMPORTANT* Change calendar_crypt_key to any random sequence of 24 characters.
* Many customizable variables can be changed to your requirements.
* Import the corresponding (MySQL, Postgres) initial SQL schema located in calendar/drivers/*/SQL/ folder to your roundcube database.
* Add "calendar" to $config['plugins'] in your Roundcube main config file.
* Login to Roundcube, click on the Calendar Tab, give it 15-30 seconds and you should be good to go.

***VERY IMPORTANT***

Your username and password must be the same for Nextcloud and Roundcube to work properly. There are no plans at this time to implement. My advice is just create your users in Nextcloud using the exact username required to login to your email server. You should have no issues.

**Known Issues**

* Will not create new calendar from Roundcube Calendar GUI.
* Recurring events marked as "All Day Events" will be a day early the following instance of it.
	* Workarounds for All Day Recurring Events
		- Do not check the "All Day" box, no issues. 
			- If you just need that box checked, do so and save it. 
			- Then edit the event and uncheck the box and save it. 
			- Then, one more time, edit the event and check that box again and save it. 
			- It will then appear properly the next time it is displayed and can be edited (as long as it is not the future instance you click to edit) and still display properly.

**Help Wanted**

If anyone would like to help out and make oauth and other features work, I would truly appreciate it.
Otherwise, issues are always welcome but I do ask that you provide as detailed info as you can ie, roundcube logs, system logs, OS info and any other pertinant information that you think can be helpful. On generic issues given without any of the preiously requesed info will delay any help I can offer you. I appreciate your understanding I do thank you ...

**Wishlist**

- [ ] Ability to add new calendar to Nextcloud from Roundcube Calendar GUI.
- [ ] Oauth support. (TBD. My skills aren't the best. :frowning_face:  ....  I need some help
- [ ] Assign random colors to autodiscover calendars.
- [ ] Add sound notifications
- [ ] Integrate a Caldav Enabled Tasklist plugin
* User requests always welcome ... :smiley_face:

**Random Color Quickie**

Multiple Calendars saved with same color. To quickly get a random coloring, just import into database `UPDATE caldav_calendars SET color = substring(MD5(RAND()), -6);` after initial sync of calendars. There is a SQL Schema located /calendar/drivers/random_color_quickie.sql to help things along quicker.

**Persistant Errors**

These errors are persistant, albeit not too often, and show up in Roundcube's errors.log. It has no rhyme or reason for when they appear. 99% of the time when these do get logged, users will be unaware as the requested task will complete successfully. As far as I can tell, it has something to do with line endings \r\n which I am looking where it may or may not be used properly. So far, no joy ..

* [29-Jan-2020 21:02:25 America/Los_Angeles] PHP Warning:  feof() expects parameter 1 to be resource, null given in /path_to_roundcube/plugins/calendar/lib/vendor/sabre/vobject/lib/Parser/MimeDir.php on line 245
* [29-Jan-2020 21:02:25 America/Los_Angeles] PHP Warning:  fgets() expects parameter 1 to be resource, null given in /path_to_roundcube/plugins/calendar/lib/vendor/sabre/vobject/lib/Parser/MimeDir.php on line 247
* [29-Jan-2020 21:02:25 America/Los_Angeles] PHP Warning:  feof() expects parameter 1 to be resource, null given in /path_to_roundcube/plugins/calendar/lib/vendor/sabre/vobject/lib/Parser/MimeDir.php on line 249
* [29-Jan-2020 21:02:25 -0800]: <179594f3> PHP Error: iCal data parse error: Error reading from input stream in /path_to_roundcube/plugins/libcalendaring on line 163 (POST /mail/?_task=calendar&_action=refresh)

*Donations*

If you like this plugin and would like to give me a donation, I would appreciate it. 
Zelle - Just send to texxasrulez@yahoo.com
[Paypal](https://paypal.me/texxasrulez?locale.x=en_US) Click it to send

I appreciate the interest in this plugin and hope all the best ...
