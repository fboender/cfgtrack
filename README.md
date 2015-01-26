cfgtrack
========

About
-----

cfgtrack tracks and reports diffs in files between invocations.

It lets you add directories and files to a tracking list by keeping a seperate
copy of the file in a tracking directory. When invoked with the 'compare'
command, it outputs a Diff of any changes made in the configuration file since
the last time you invoked with the 'compare' command. It then automatically
updates the tracked file.

Limitations (otherwise known as "features")

- Does not track file attribute changes (future?)
- Does not track who made the change (future?)
- Does not track additions to directories (but does track removals of tracked
  files) (future?).
- Does not send email, since there is no portable way to send emails from the
  shell.

Example:

    [fboender@jib]~$ sudo ./cfgtrack track /etc/crontab 
    Now tracking /etc/crontab

    # Two weeks later

    [fboender@jib]~$ sudo ./cfgtrack compare
    --- ./etc/crontab   2015-01-23 18:23:06.906938089 +0100
    +++ /./etc/crontab  2015-01-23 18:23:26.842937817 +0100
    @@ -12,6 +12,3 @@
    25 6 * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
    47 6 * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
    52 6 1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
    -# MISSION CRITICAL: DO NOT REMOVE
    -00 3    1 * *   root    /usr/local/bin/fix_all_the_things.py
    -

    [fboender@jib]~$ echo "Oh god, why???" | mail -s "YOU'RE FIRED" --to admin@noobcorp.com


Installation
------------

cfgtrack is written as a straight-forward portable shell script. No special
installation is required other than downloading and copying the script to a
directory.

### Manual install

1. Download the .tar.gz file
2. Unpack it with `tar -vxzf cfgtrack-*.tar.gz
3. Change to the cfgtrack directory: `cd cfgtrack*`
3. Install it on your system with `sudo make install`
3. Uninstall it from your system with `sudo make uninstall`

### Debian / Ubuntu / Linux Mint installation

1. Download the .deb file: 
2. Install the package: `sudo dpkg -i cfgtrack*.deb`
3. To uninstall: `apt-get purge cfgtrack`


Usage
-----

To start tracking an entire tree of files:

    $ sudo cfgtrack track /etc/

To track a single file:

    $ sudo cfgtrack track /etc/apt/apt.conf.d/50unattended-upgrades

Note that cfgtrack keeps a copy of the files that are tracked in a seperate dir.
If you track large directories (which you really shouldn't), this will take up
twice as much space.

To show differences between the last time you ran 'compare' and now:

    $ sudo cfgtrack compare

To stop tracking changes to an entire tree of files:

    $ sudo cfgtrack untrack /etc/

To stop tracking changes to a single file

    $ sudo cfgtrack untrack /etc/apt/apt.conf.d/50unattended-upgrade

See also `man 1 cfgtrack`
