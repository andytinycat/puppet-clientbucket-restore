puppet-clientbucket-restore
===========================

Ruby script for interactively restoring files from a Puppet client's clientbucket.

If you've accidently overwritten, with Puppet, a file you meant to keep, then this script can get it back.
The real filebucket stuff provided by Puppetlabs requires the md5 of the old file you want to restore. This
script goes and looks for all the available versions of a file, and allows you to diff, view, or restore one
or more of these older versions.

Run the script like this:

    clientbucket.rb -t /path/to/file -c path/to/client/bucket

Where /path/to/file is the file on the system that you're looking for old versions of. If you run it by itself, it will return the following help screen:

    Usage: clientbucket.rb -t target_path -c clientbucket_path
        -t, --target_path target_path    path of the file to restore
        -c clientbucket_path,            where to restore from. Defaults to /var/lib/puppet/clientbucket
            --clientbucket_path
        -h, --help  

The script runs interactively and prompts you for what you want to do. An example:

    # clientbucket.rb -t /some/test/file
    [0]: 41f59421026a473a0378c58d539069c6 Thu Feb 09 15:56:36 +0000 2012
    [1]: 6bc6ab38660066ea8cf0743b889bd075 Mon Feb 20 15:23:59 +0000 2012
    [2]: 74da6d605bfd7ecad38904bc35a0292a Thu May 24 13:45:10 +0100 2012
    [3]: 3d7e9c6901aa0bc4dd7e6400384931c3 Thu May 24 13:48:57 +0100 2012
    [4]: 6bbb4aeeec2f439ec22be9813bbf049a Thu May 24 13:50:51 +0100 2012
    [5]: 2800331718994ab1e9ca84549b9debbb Thu May 24 15:39:56 +0100 2012
    [6]: 1a432127a080c77dde1cf14e18bcf4aa Thu May 24 15:43:32 +0100 2012
    ------------------------
    Pick a file, or x to exit: 2
    Restore (r), view (v), diff (d), unified diff (u), or x to go back: d
    1c1
    < HEY THERE
    ---
    > HELLO THERE
    Restore (r), view (v), diff (d), unified diff (u), or x to go back: r
    Restore to (default is to restore to /some/test/file: <enter>
    Restoring to /some/test/file
    Done
  
