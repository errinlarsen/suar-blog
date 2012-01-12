title: Installing PickMe
date: 2012-01-12 12:15pm

I wanted my other current project, my [PickMe
app](http://github.com/errinlarsen/pickme), to be hosted on my RackSpace
server as well as this blog.  I thought I could simply:

1. Clone the code
2. Create an /etc/thin/pickme.yml
3. Create an /etc/apache2/sites-available/pickme
4. Stop the Thin service
5. Restart the Apache service
6. Start the Thin service

We'll see ...

## 1. Clone the app

    _
    elarsen@app1:~$ sudo su - deployer
    [sudo] password for elarsen: 

    deployer@app1:~$ git clone git@github.com:errinlarsen/pickme.git
    Initialized empty Git repository in /home/deployer/pickme/.git/
    remote: Counting objects: 409, done.
    remote: Compressing objects: 100% (272/272), done.
    remote: Total 409 (delta 171), reused 359 (delta 121)
    Receiving objects: 100% (409/409), 7.83 MiB | 3.24 MiB/s, done.
    Resolving deltas: 100% (171/171), done.

    deployer@app1:~$ cd pickme/

    deployer@app1:~/pickme$ ls
    Gemfile  Gemfile.lock  cards  features	models	pickme.rb  spec  vendor  views

    deployer@app1:~/pickme$ bundle install --deployment
    Installing builder (3.0.0) 
    Installing mime-types (1.17.2) 
    Installing nokogiri (1.5.0) 
    Installing rack (1.4.0) 
    Installing rack-test (0.6.1) 
    Installing ffi (1.0.11) 
    Installing childprocess (0.2.9) 
    Installing multi_json (1.0.4) 
    Installing rubyzip (0.9.5) 
    Installing selenium-webdriver (2.16.0) 
    Installing xpath (0.1.4) 
    Installing capybara (1.1.2) 
    Installing minitest (2.10.0) 
    Installing capybara_minitest_spec (0.2.1) 
    Installing diff-lcs (1.1.3) 
    Installing json (1.6.4) with native extensions 
    Installing gherkin (2.7.3) with native extensions 
    Installing term-ansicolor (1.0.7) 
    Installing cucumber (1.1.4) 
    Installing haml (3.1.4) 
    Installing rack-protection (1.2.0) 
    Installing tilt (1.3.3) 
    Installing sinatra (1.3.2) 
    Installing bundler (1.0.21) 
    Updating .gem files in vendor/cache
    Your bundle is complete! It was installed into ./vendor/bundle

So far, so good!

## 2. Create an /etc/thin/pickme.yml

    _
    elarsen@app1:~$ sudo cp /etc/thin/suar-blog.yml /etc/thin/pickme.yml

    elarsen@app1:~$ sudo vim /etc/thin/pickme.yml
        user: deployer
        group: deployer
        chdir: /home/deployer/pickme
        log: log/thin.log
        port: 5002
        environment: production
        address: 127.0.0.1
        pid: tmp/pids/thin.pid
        servers: 1

Ok, that wasn't too hard.  I increased the port number so we wouldn't conflict
with the blog's port.  I changed the directory to run the server out of, and
... well, that's all I changed!

## 3. Create an /etc/apache2/sites-available/pickme

    _
    elarsen@app1:~$ sudo cp /etc/apache2/sites-available/suar-blog /etc/apache2/sites-available/pickme

    elarsen@app1:~$ sudo vim /etc/apache2/sites-available/pickme 
        <VirtualHost *:80>
          ServerName pickme.irkeninvader.com
          ErrorLog /var/log/apache2/pickme.log

          # Possible values include: debug, info, notice, warn, error, crit,
          # alert, emerg.
          LogLevel warn

          CustomLog /var/log/apache2/access.log combined

          ProxyPass / http://127.0.0.1:5002/
          ProxyPreserveHost on

          <Location />
            ProxyPassReverse /
            Allow from all
          </Location>
        </VirtualHost>

Ok.  Again, not so bad.  I copied the virtual host for this blog and made a
couple modifications.  I changed ServerName, the ErrorLog, and finally, the
port for the reverse proxy.  I think this will work out.

## Steps 4, 5, and 6: Restarting the web servers

    _
    elarsen@app1:~$ sudo service thin stop
    [stop] /etc/thin/pickme.yml ...
    Stopping server on 127.0.0.1:5002 ... 
    Can't stop process, no PID found in tmp/pids/thin.5002.pid
    [stop] /etc/thin/suar-blog.yml ...
    Stopping server on 127.0.0.1:5001 ... 
    Sending QUIT signal to process 25411 ... 

    elarsen@app1:~$ sudo a2ensite pickme
    Enabling site pickme.
    Run '/etc/init.d/apache2 reload' to activate new configuration!

    elarsen@app1:~$ sudo service apache2 restart
     * Restarting web server apache2                                                                                         ... waiting                                                                                                     [ OK ]

    elarsen@app1:~$ sudo service thin start
    [start] /etc/thin/pickme.yml ...
    Starting server on 127.0.0.1:5002 ... 
    [start] /etc/thin/suar-blog.yml ...
    Starting server on 127.0.0.1:5001 ...
    
Note the step for enabling the new virtual host in the above.  These steps
seemed to go pretty smooth.

## Checking out the results
### Blog
... working as it was before.

### PickMe
... nope.

Going to http://pickme.irkeninvader.com resulted in a **Service Temporarily
Unavailable** message.  *The server is temporarily unable to service your
request due to maintenance downtime or capacity problems.  Please try again
later."*, it continued.  This is an Apache error message.  Let's go check some
logs and see what's going on.

## Debuging the PickMe app

    _
    elarsen@app1:~$ sudo cat /var/log/apache2/pickme.log
    [Thu Jan 12 12:36:58 2012] [error] (111)Connection refused: proxy: HTTP: attempt to connect to 127.0.0.1:5002 (127.0.0.1) failed
    [Thu Jan 12 12:36:58 2012] [error] ap_proxy_connect_backend disabling worker for (127.0.0.1)
    [Thu Jan 12 12:36:58 2012] [error] proxy: HTTP: disabled connection for (127.0.0.1)

Ah-ha!  It appears the server isn't even running.  No wonder Apache can't pass
the request off.

Let's look at the PickMe app's log ...

    _
    elarsen@app1:~$ sudo cat thin.5002.log 
    >> Writing PID to tmp/pids/thin.5002.pid
    >> Changing process privilege to deployer:deployer
    No adapter found for /home/deployer/pickme
    >> Exiting!
    /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:158:in `delete': Permission denied - tmp/pids/thin.5002.pid (Errno::EACCES)
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:158:in `remove_pid_file'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:59:in `block in daemonize'

I've seen this before.  I know what's going on.  There is no log/ nor tmp/
directory in the project files under git control.  Therefore, when we cloned
the repo, those directories were not created.  When we asked Thin to put things
in those directories (see step 1, above), it **helpfully** created them for us,
but at the time, Thin was running with root privileges.  Therefore, the
directories were created as owned by root.  When the deployer user tried to
write/modify files owned by root, we got permission errors, and the server
never started.  I can fix that up real quick and then restart Thin.

## Fixing the permission problems and restarting

    _
    elarsen@app1:~$ sudo chown -R deployer:deployer ~deployer/pickme/log
    elarsen@app1:~$ sudo chown -R deployer:deployer ~deployer/pickme/tmp

    elarsen@app1:~$ sudo service thin restart
    [restart] /etc/thin/pickme.yml ...
    Stopping server on 127.0.0.1:5002 ... 
    Sending QUIT signal to process 28805 ... 
    process not found!
    Sending KILL signal to process 28805 ... 
    /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:140:in `kill': No such process (Errno::ESRCH)
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:140:in `force_kill'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:134:in `rescue in send_signal'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:118:in `send_signal'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/daemonizing.rb:107:in `kill'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/controllers/controller.rb:93:in `block in stop'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/controllers/controller.rb:134:in `tail_log'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/controllers/controller.rb:92:in `stop'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/runner.rb:185:in `run_command'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/lib/thin/runner.rb:151:in `run!'
      from /usr/local/lib/ruby/gems/1.9.1/gems/thin-1.3.1/bin/thin:6:in `<top (required)>'
      from /usr/local/bin/thin:19:in `load'
      from /usr/local/bin/thin:19:in `<main>'
    Starting server on 127.0.0.1:5002 ... 
    >> Deleting stale PID file tmp/pids/thin.5002.pid
    [restart] /etc/thin/suar-blog.yml ...
    Stopping server on 127.0.0.1:5001 ... 
    Sending QUIT signal to process 28821 ... 
    Starting server on 127.0.0.1:5001 ... 

Whoah!  That was ugly, but expected.  The last time Thin started the pickme
server, the root user created the .pid file.  Then, when it stopped working,
the deployer user tried to clean up, but didn't have permissions to that file!

Everything seems to be working, now!

## Apache's Rewrite module
I noticed something after the above work.  All traffic to
http://irkeninvader.com, http://www.irkeninvader.com, and
http://pickme.irkeninvader.com all go to the same place.  First of all, a good
question: Now that I have two sites on my server, which one do I want to be
"default"?  Let's say the Blog should be default.  Also, let's try to set it
up so that anyone that gets to the blog with irkeninvader.com or
www.irkeninvader.com will have their URL bar re-written with
blog.irkeninvader.com to aleviate any confusion.

Let's change the VirtualHost file for the blog first; explanations after:

    _
    elarsen@app1:~$ sudo vim /etc/apache2/sites-available/suar-blog
        <VirtualHost *:80>
          ServerName blog.irkeninvader.com
          ServerAlias www.irkeninvader.com
          ServerAlias irkeninvader.com
          ErrorLog /var/log/apache2/suar-blog.log

          # Possible values include: debug, info, notice, warn, error, crit,
          # alert, emerg.
          LogLevel warn

          CustomLog /var/log/apache2/access.log combined

          ProxyPass / http://127.0.0.1:5001/
          ProxyPreserveHost on

          <Location />
            ProxyPassReverse /
            Allow from all
          </Location>

          RewriteEngine On
          RewriteCond %{HTTP_HOST}   !^blog\.irkeninvader\.com [NC]
          RewriteCond %{HTTP_HOST}   !^$
          RewriteRule ^/(.*)         http://blog.irkeninvader.com/$1 [L,R]
        </VirtualHost>

Ok.  First, why does www.irkeninvader.com or irkeninvader.com go to the PickMe
app?  Well, it turns out, when Apache is faced with an ambiguous choice between
two (or more) different VirtualHost entries, it will pick the first one it
comes to; that is, the first one loaded.  As we know, "pickme" is
alphabetically ahead of "suar-blog", so when Apache is loading all the
VirtualHost entries in the /etc/apache2/sites-enabled directory, it will load
pickme first.  There ya have - pickme became default.

So, to fix this, I just needed the choice of which VirtualHost to resolve
irkeninvader.com and www.irkeninvader.com to to not be ambiguous.  I did that
above by adding some ServerAlias entries to the VirtualHost definition.  
Now Apache knows exactly where I want it to go.  The next step is a little
more difficult.

There is a (powerful) Apache module called **mod_rewrite** that lets you do all
kinds of re-writing tasks, not the least of which is rewriting URLs.  I had to
enable the module, which I did like this:

    _
    elarsen@app1:~$ sudo a2enmod rewrite
    Enabling module rewrite.
    Run '/etc/init.d/apache2 restart' to activate new configuration!

    elarsen@app1:~$ sudo service apache2 restart
     * Restarting web server apache2                                                                                         ... waiting

Then, I added the above 4 RewriteXXX lines to the VirtualHost definition for
the blog.  The in-depth description of what is going on in there is outside the
scope of this (already very lengthy!) blog entry, but I'll try to summarize.

* Any incoming requests for anything that isn't exactly 'blog.irkeninvader.com'
  (or blank) will be rewritten so they look like they were originally going to
  blog.irkeninvader.com.
* Everything after the first slash, including the first slash, will be appended
  to the end of the newly rewritten URL

## All done!
Anyway - everything is hooked up, working and serving the pages I want served
to the right addresses.
