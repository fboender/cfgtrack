cfgtrack
========

Download: https://github.com/fboender/cfgtrack/releases/

Packages available for: Debian, Ubuntu, Redhat, .tar.gz.


About
-----

cfgtrack tracks and reports diffs in files between invocations.

It lets you add directories and files to a tracking list by keeping a seperate
copy of the file in a tracking directory. When invoked with the 'compare'
command, it outputs a Diff of any changes made in the configuration file since
the last time you invoked with the 'compare' command. It then automatically
updates the tracked file. It can also send an email with the diff attached.

Limitations (otherwise known as "features")

- Does not track file attribute changes (future?)
- Does not track who made the change (future?)
- Does not track additions to directories (but does track removals of tracked
  files) (future?).

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

If you want to to use the mail function (-m/--mail), you'll need Python.

### Debian / Ubuntu / Linux Mint installation

1. Download the .deb file from https://github.com/fboender/cfgtrack/releases/
2. Install the package: `sudo dpkg -i cfgtrack*.deb`
3. To uninstall: `apt-get purge cfgtrack`

If you want to use the mail (-m) option, Python (v2.5+) must be installed.
Python is available on nearly all unices.

### RedHat / Centos / RPM-based

1. Download the .rpm file from https://github.com/fboender/cfgtrack/releases/
2. Install the package: `sudo rpm -i cfgtrack*.rpm`

If you want to use the mail (-m) option, Python (v2.5+) must be installed.
Python is available on nearly all unices.

### Manual install

1. Download the .tar.gz or .zip file from https://github.com/fboender/cfgtrack/releases/
2. Unpack it with `tar -vxzf cfgtrack-*.tar.gz`
3. Change to the cfgtrack directory: `cd cfgtrack*`
4. Install it on your system with `sudo make install`
5. Uninstall it from your system with `sudo make uninstall`

If you want to use the mail (-m) option, Python (v2.5+) must be installed.
Python is available on nearly all unices.


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

To send an email upon changes:

    $ sudo --silent --mail admin@example.com compare

To stop tracking changes to an entire tree of files:

    $ sudo cfgtrack untrack /etc/

To stop tracking changes to a single file

    $ sudo cfgtrack untrack /etc/apt/apt.conf.d/50unattended-upgrade

To get a daily report via email of changes:

    $ vi /etc/cron.daily/scriptform
    #!/bin/sh
    
    /usr/bin/cfgtrack -a -m admin@foocorp.com compare >/dev/null

    $ chmod 755 /etc/cron.daily/scriptform


See also `man 1 cfgtrack`
