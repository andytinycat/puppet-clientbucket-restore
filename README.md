puppet-clientbucket-restore
===========================

Ruby script for interactively restoring files from a Puppet client's clientbucket.

If you've accidently overwritten, with Puppet, a file you meant to keep, then this script can get it back.
The real filebucket stuff provided by Puppetlabs requires the md5 of the old file you want to restore. This
script goes and looks for all the available versions of a file, and allows you to diff, view, or restore one
or more of these older versions.

Run the script like this:

clientbucket.rb /path/to/file

Where /path/to/file is the file on the system that you're looking for old versions of.
