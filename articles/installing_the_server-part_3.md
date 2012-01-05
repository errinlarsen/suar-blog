title: Installing the server - part 3
date: 2012-1-5 10am

This continues the record of my adventures in server building started in [part 1](http://blog.irkeninvader.com/installing_the_server-part_1) and [part
2](http://blog.irkeninvader.com/installing_the_server-part_2).

## Bundler
First, a quick _gem install bundler_ as root to make sure bundler is available for all
projects

## Blog software
Then, as the deployer user, I set up the .ssh/ directory and .ssh/config file to
handle logging in to git for deployment purposes.  I created an SSH key and
added the pub key to my account in GitHub.

    _
    $ cat ~/.ssh/config
    Host github.com
      User git
      IdentityFile ~/.ssh/id_rsa.github
    $ ssh-keygen -f ~/.ssh/id_rsa.github
    $ cat .ssh/id_rsa.github.pub

Next up was pulling the blog project down to the server

    _
    $ git clone git@github.com:errinlarsen/suar-blog.git

I like keeping my project-specific gems vendored, so, remaining the deployer
user, I ran a quick _bundle install_.

    _
    $ cd suar-blog.git
    $ bundle install --deployment

At this point, the project is ready to go - but I didn't have a web server yet!

## Apache
For the next step, I switched over to the root user to install apache2

    _
    # apt-get install apache2

I didn't have any modifications to make for the main apache2 config
(/etc/apache2/apache2.conf), so I left that alone.  I did plan on using apache
as a reverse proxy, so I need to enable mod_proxy.

    _
    # a2enmod proxy_http

Next up, I created a new site file in /etc/apache2/sites-available.  I called it _suar-blog_, the same name as the project in git:

    _
    # cat /etc/apache2/sites-available/suar-blog
    <VirtualHost *:80>
      ServerName blog.irkeninvader.com
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
    </VirtualHost>

Notice the ProxyPass line - it's telling Apache to pass all traffic coming to the VirtualHost (*:80 right now) to a server running on the localhost (127.0.0.1) on port 5001.  At that moment, nothing was running there to listen to requests.  This brings up the next step …

## Thin server
Again, as the root user, I installed the Thin server.

    _
    # gem install thin

According to the Thin server documentation, we can set up Thin to start at boot-time and act like a service by running _thin install_.  After that, it's a matter of putting our Thin server config files into /etc/thin and then, treating thin like a service, just start it up!

    _
    # thin install
    # cat /etc/thin/suar-blog.yml
    user: deployer
    group: deployer
    chdir: /home/deployer/suar-blog
    log: log/thin.log
    port: 5001
    environment: production
    address: 127.0.0.1
    pid: tmp/pids/thin.pid
    servers: 1
    # service thin start

The above _suar-blog.yml_ configuration file is telling Thin to start up a single server on the localhost (127.0.0.1) listening on port 5001.  This server should be run as the deployer user and group after first changing the current working directory to /home/deployer/suar-blog.  This is going to expect there to be a _config.ru_ file in that directory to tell it what to do.  Let's take a look:

    _
    # cat /home/deployer/suar-blog/config.ru
    require "bundler/setup"
    $LOAD_PATH.unshift "lib"
    
    # this is optional
    require "rack/cache"
    use Rack::Cache
    
    require "blog"
    run Blog

Yup, that's the suar-blog's config.ru file.

With all that hooked up and the Thin server running, we can start up enable our star-blog site and restart Apache:

    _
    # a2ensite suar-blog
    # service apache2 restart

Now, when we visit http://blog.irkeninvader.com, we should see the blog!  Yay!

## More to come ...
That's it for now.  I'll continue in part 4.

[part 1](http://blog.irkeninvader.com/installing_the_server-part_1) | [part
2](http://blog.irkeninvader.com/installing_the_server-part_2) | part 3
