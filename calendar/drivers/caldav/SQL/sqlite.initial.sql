PRAGMA journal_mode = MEMORY;
PRAGMA synchronous = OFF;
PRAGMA foreign_keys = OFF;
PRAGMA ignore_check_constraints = OFF;
PRAGMA auto_vacuum = NONE;
PRAGMA secure_delete = OFF;
BEGIN TRANSACTION;

CREATE TABLE IF NOT EXISTS `caldav_calendars` (
`calendar_id` INTEGER  NOT NULL ,
`user_id` INTEGER  NOT NULL DEFAULT '0',
`name` TEXT NOT NULL,
`color` TEXT NOT NULL,
`showalarms` tinyINTEGER NOT NULL DEFAULT '1',
`caldav_url` TEXT NOT NULL,
`caldav_tag` TEXT DEFAULT NULL,
`caldav_user` TEXT DEFAULT NULL,
`caldav_pass` TEXT DEFAULT NULL,
`caldav_oauth_provider` TEXT DEFAULT NULL,
`readonly` int NOT NULL DEFAULT '0',
`caldav_last_change` timestamp NOT NULL ,
PRIMARY KEY(`calendar_id`),
INDEX `caldav_user_name_idx` (`user_id`, `name`),
FOREIGN KEY (`user_id`)
REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `caldav_events` (
`event_id` INTEGER  NOT NULL ,
`calendar_id` INTEGER  NOT NULL DEFAULT '0',
`recurrence_id` INTEGER  NOT NULL DEFAULT '0',
`uid` TEXT NOT NULL DEFAULT '',
`instance` TEXT NOT NULL DEFAULT '',
`isexception` tinyINTEGER NOT NULL DEFAULT '0',
`created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`sequence` INTEGER  NOT NULL DEFAULT '0',
`start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
`recurrence` TEXT DEFAULT NULL,
`title` varbinary(128) NOT NULL,
`description` varbinary(2048) NOT NULL,
`location` TEXT NOT NULL DEFAULT '',
`categories` TEXT NOT NULL DEFAULT '',
`url` TEXT NOT NULL DEFAULT '',
`all_day` tinyINTEGER NOT NULL DEFAULT '0',
`free_busy` tinyINTEGER NOT NULL DEFAULT '0',
`priority` tinyINTEGER NOT NULL DEFAULT '0',
`sensitivity` tinyINTEGER NOT NULL DEFAULT '0',
`status` TEXT NOT NULL DEFAULT '',
`alarms` text NULL DEFAULT NULL,
`attendees` text DEFAULT NULL,
`notifyat` datetime DEFAULT NULL,
`caldav_url` TEXT NOT NULL,
`caldav_tag` TEXT DEFAULT NULL,
`caldav_last_change` timestamp NOT NULL ,
PRIMARY KEY(`event_id`),
INDEX `caldav_uid_idx` (`uid`),
INDEX `caldav_recurrence_idx` (`recurrence_id`),
INDEX `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`),
FOREIGN KEY (`calendar_id`)
REFERENCES `caldav_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS `caldav_attachments` (
`attachment_id` INTEGER  NOT NULL ,
`event_id` INTEGER  NOT NULL DEFAULT '0',
`filename` TEXT NOT NULL DEFAULT '',
`mimetype` TEXT NOT NULL DEFAULT '',
`size` INTEGER NOT NULL DEFAULT '0',
`data` TEXT NOT NULL,
PRIMARY KEY(`attachment_id`),
FOREIGN KEY (`event_id`)
REFERENCES `caldav_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
);
REPLACE INTO `system` (`name`, `value`) VALUES ('texxasrulez-caldav_calendar', '2020072000');

COMMIT;
PRAGMA ignore_check_constraints = ON;
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
