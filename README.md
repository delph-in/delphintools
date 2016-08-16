Delphin Tools: scripts for automating parsing, translation, and generation within the Delphin HPSG framework

Author: Eric Nichols <ericnichols79@gmail.com> Nara Institute of Science and Technology


INSTALLATION
------------

* Via git

        $ git clone 'https://github.com/delph-in/delphintools.git' /path/to/delphintools

* Via zip file

        $ wget 'https://github.com/delph-in/delphintools/archive/master.zip' -O /path/to/delphintools.zip
        $ cd /path/to/
        $ unzip delphintools.zip
        $ mv delphintools-master delphintools


SHELL ENVIRONMENT SETUP
-----------------------

Add the following to your `.bashrc`

    # Batch processing with Delphin
    DTHOME=/path/to/delphintools
    if [ -f $DTHOME/setup.sh ]; then
        . $DTHOME/setup.sh
    fi


AUTOMATION WITH LOGON_DO
------------------------

`delphintools/bin/logon_do` provides a simple interface for parsing, tranlating, and generating using the LOGON binary. It automatically creates a collection of profiles from a bitext-formatted input file.


CREATING A PROFILE TOP
----------------------

Prior to any processing, `logon_do` should be invoked with the `--bitext` (or `-b` option) to create a directory to store future profiles in:

    $ logon_do --bitext /path/to/bitext.txt /path/to/profile_top
    $ ls /path/to/profile_top/*
    /path/to/profile_top/bitext:
    object  original

The above command will create the directory `/path/to/profile_top` and a subdirectory `bitext/` that contains the original bitext file (called 'original') and a bitext file with the source and target language swapped ('object') that is used for parsing and paraphrasing the target langauge.

--------------
USING LOGON_DO
--------------

**usage:** `logon_do -g|--grammar <jaen|enen> -t|--task <smrs|tmrs|pmrs|gmrs|vmrs|omrs|imrs> [/path/to/profile_top]`

Calling `logon_do` in the following manner will create the profile `/path/to/profile_top/smrs` and parse the source sentences in `bitext/`original with the Japanese grammar Jacy.

    $ logon_do --grammar jaen --task smrs /path/to/profile_top

If `/path/to/profile` is omitted, `logon_do` will default to the current directory. So the following command is equivalent:

    $ cd /path/to/profile_top && logon_do --grammar jaen --task smrs

Once parsing is complete, the profile `smrs` will contain the parse results:

    $ ls /path/to/profile/smrs
    analysis  decision  fold  item-phenomenon  output     parse       preference  result  run    set   update
    daughter  edge      item  item-set         parameter  phenomenon  relations   rule    score  tree

------------------
SUPPORTED GRAMMARS
------------------

Currently, the following grammars are supported.

* `jaen`: Japanese->English translation
* `enen`: English->English paraphrasing (omrs and imrs are supported)

Users can add support for their own systems by copying and modifying the settings files for an existing grammar to call appropriate TSDB CPUs for each task:

    $ cp -r lisp/jaen lisp/koen
    $ emacs lisp/koen/*.lisp

---------------
SUPPORTED TASKS
---------------

Currently, the following tasks are supported.

* `smrs`: MRS from parsing source language
* `tmrs`: MRS from applying transfer grammar to smrs
* `pmrs`: "partial transfer" results -- MRS containing mix of translated and untranslated rels from applying transfer grammar to smrs
* `gmrs`: MRS from applying generation grammar to tmrs
* `vmrs`: variants (i.e. paraphrases) of source language parses in smrs
* `omrs`: MRS from parsing "object" (i.e. target) language
* `imrs`: "iikae" (i.e. paraphrases) of target language parses in omrs

----------------
LOGON_DO OPTIONS
----------------

`logon_do` supports the following command line arguments:

* `--count|-c`: sets the number of cpus to allow a task to run in parallel.
* `--debug|-d`: output lisp code without calling LOGON binary for debugging purposes.
* `--edges|-e`: sets the number of edges to use for parsing and generation. transfer is not affected by this setting.
* `--limit|-l`: sets the number of results to store for a task. also determines the number of dependency results to use.
* `--settings|-s`: loads a user-specified settings file of arbitrary lisp code. see `lisp/settings/` for examples. defaults to `lisp/settings/default.lisp`


-------------------------------
PROFILE TOP DIRECTORY STRUCTURE
-------------------------------

`profile_top` has the following directory structure. tmrs, pmrs, gmrs, and vmrs store their profiles in subdirectories that match the result-id of the dependency used to create them.

    /path/to/profile_top/bitext/original
                        /bitext/object
                        /smrs/
                        /tmrs/0/
                        /pmrs/0/
                        /gmrs/0/0/
                        /vmrs/0
                        /omrs/
                        /imrs/0/
