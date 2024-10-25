**Command Vs Shell**</br>
Why use shell instead of command? Ansible’s command module is the
preferred option for running commands on a host (when an Ansible module
won’t suffice), and it works in most scenarios. However, command doesn’t
run the command via the remote shell /bin/sh, so options like <, >, |, and &,
and local environment variables like $HOME won’t work. shell allows you
to pipe command output to other commands, access the local environment,
etc.
There are two other modules which assist in executing shell commands
remotely: script executes shell scripts (though it’s almost always a better
idea to convert shell scripts into idempotent Ansible playbooks!), and raw
executes raw commands via SSH (it should only be used in circumstances
where you can’t use one of the other options).



**Re-downloading with get_url**</br>
If you pass a directory to the dest
parameter, Ansible will place the file inside, but will always re-download the file
on subsequent runs of the playbook (and overwrite the existing download if it has
changed). To avoid this extra overhead, we give the full path to the downloaded file. </br>
Below is an example: </br>
get_url: </br>
  &nbsp;url: some url_given </br>
  &nbsp;dest: "{{download_dir/target_file_name}}" # This will check for the file before downloading
  &nbsp;dest: "{{download_dir/}}" #In this case you won't have a check it will download the file every time you want to download it and will overwrite it. 

**Overriding Handlers behavior** </br>
By default Handlers run once all the plays in a playbook run, but if it is required to run the handlers before finishing off with the playbbok `- meta: flush_handlers ` can be used to do that

If a play fails, the handlers won't be notified, but this can also be overriden using `--force-handlers` in the command line </br>

**Variables**</br>
  &nbsp;Standard is to use all lowercase letters for variables</br> 
  &nbsp;Invalid varialbe names: </br>
  &nbsp;&nbsp;foo-bar</br>
  &nbsp;&nbsp;A Number </br>
  &nbsp;&nbsp;foo.bar </br>
  &nbsp;&nbsp;foo bar</br>
  &nbsp; In a var File it is assigned using = sign </br>
  &nbsp; In a playbook it is assigned using : sign </br>
  