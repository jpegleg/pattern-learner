pattern-learner:
Read the Simple Event Correlator documentation: https://simple-evcorr.github.io/

A sec.pl and bash pattern learner which identifies unique occurrences in text lines for system alerting and auditing.

The default pattern trigger is the following string:

Deny

Whenever that string is matched in /var/log/net.log, a sec.pl child process will spawn 
the shell script /usr/local/bin/deny-sorter which will pull strings that match Deny from
/var/log/net.log and check to see if that pattern has been found before.  The shell script
also writes a lock file with the patterns contents. Those lock files are a way to control
the alerting in real time if you so desire; remove a lock file to trigger that pattern on the
next match.

Once the Deny pattern is matched excluding the archive of occurrences and no lock file exists, the data will be written to /var/log/new-deny.log
This is a log which has every unique Deny pattern that has been found. This log is read by another sec.pl 
child process which sends each line as an email to root@localhost. Adjust that email by editing the

/etc/learner-watcher.cfg

The maximum locks ( known patterns ) will be different on each machine. I am working on a standardized lock file management system to add to this, but for now that is up to you.

HOW TO INSTALL:
==============================================
Download all of the files and then run the installer:

And run the install script:
chmod +x ./pattern-learner-installer.sh
sudo ./pattern-learner-installer.sh
