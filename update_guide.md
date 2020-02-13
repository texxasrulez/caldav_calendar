# Updating from 0.5.x to 0.6.x Instructions

**Lots of changes, so it is just best to start over, sort of.**

A clean install is required, so I recommend the following procedures:

**Beginner**

* Login to webserver. (FTP is recommended method. SSH is fine if you are skilled in the SSH Arts. I would not use composer update method.)
* Navigate to your /roundcube_directory/plugins
* Rename folders/directories calendar, libcalendaring and libkolab (if present) to calendar2, libcalendaring2 and libkolab2 (if present)
* Download the latest [Release](https://github.com/texxasrulez/caldav_calendar/releases/latest) for Caldav_Calendar.
* Unzip contents
* Upload folders calendar, libcalendaring and libkolab to /roundcube_directory/plugins/
* Navigate to /roundcube_directory/plugins/ and rename config.inc.php.dist to config.inc.php and edit the URL's within config to match your Domain and Nextcloud install directory name as well as customize the many variables to your preferences. Use the same calendar_crypt_key from your original config.inc.php if keeping database tables.
* Login to your sql server and backup the tables caldav_attachments, caldav_calendars and caldav_events under your Roundcube database
* If you do not want to redo attachments or invitations manually, skip next step (This potentially can cause issues, the risk is low, remember to use the same calendar_crypt_key from your original config.inc.php)
* TRUNCATE the tables caldav_attachments, caldav_calendars and caldav_events within your Roundcube database
* Login to Roundcube like normal, click on Calendar Tab and give it 15-30 seconds to re-sync, and then BOOM - Should be repopulated with your calendars and events
* If you care what color your calenders are, you can edit calendar color accordingly within Roundcube Calendar GUI at anytime, so skip next step
* Go back to your SQL terminal and import into database `UPDATE caldav_calendars SET color = substring(MD5(RAND()), -6);` to assign randmon colors after initial sync of calendars
* Logout of your SQL server. (Just a friendly reminder)
* If all works well, delete the directories calendar2, libcalendaring2 and libkolab2 (if present) from your /roundcube_directory/plugins/ directory. Logout of your FTP/SSH Client and ... BOOM!, You are done ... Enjoy


**Expert**
* Download Latest [Release](https://github.com/texxasrulez/caldav_calendar/releases/latest) or Latest [commit](https://github.com/texxasrulez/caldav_calendar/archive/master.zip) , Dealers Choice
* delete calendar, libcalendaring and libkolab (if there) directories 
* Do yo thang
* Enjoy


:moneybag: **Donations** :moneybag:

If you use this plugin and would like to show your appreciation by buying me a cup of coffee, I surely would appreciate it. A regular cup of Joe is sufficient, but a Starbucks Coffee would be better ... \
Zelle (Zelle is integrated within many major banks Mobile Apps by default) - Just send to texxasrulez at yahoo dot com \
No Zelle in your banks mobile app, no problem, just click [Paypal](https://paypal.me/texxasrulez?locale.x=en_US) and I can make a Starbucks run ... \
If you got the skills to and would prefer to donate your time to this project, I welcome it and NEED it .. 

Many Thanks and have a great day ...

