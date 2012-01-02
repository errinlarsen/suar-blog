title: Installing the server - part 2
date: 2012-1-2 8:30am

This continues the record of my adventures in server building started in [part
1](http://blog.irkeninvader.com/installing_the_server-part_1).

## Users
After standing up the server, my first step was to create a couple of useful
users; one for me and one for web apps.

    
    $ useradd elarsen
    $ passwd elarsen
    $ mkdir -p /home/elarsen/.ssh
    $ chown -R elarsen:elarsen /home/elarsen

    $ useradd deployer
    $ mkdir -p /home/deployer/.ssh
    $ chown -R deployer:deployer /home/deployer

After making sure I could login and get around with the elarsen user, I setup
sudo.  I created a sudo group, added elarsen to that group, and then added the
following line to the /etc/sudoers file:

    
    %sudo ALL=(ALL) ALL

Finally, I set up elarsen's .ssh/authorized_keys to allow me to login easily.

## Package installs
Obviously, I'm going to need Ruby.  I plan to pull down and compile the latest
ruby 1.9.3-p0, so I'm going to need a lot of build-essential type packages.
While I'm at it, I also want to grab some other essentials (like git, and
screen).

    
    $ apt-get install build-essential bison openssl libreadline6 \
      libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev \
      libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev autoconf screen

Next up, pulling the source, unpacking, compiling, and installing:

    
    $ cd /usr/local/src
    $ wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
    $ tar xzvf yaml-0.1.4.tar.gz 
    $ cd yaml-0.1.4
    $ ./configure --prefix=/usr/local
    $ make && make install

    $ cd /usr/local/src
    $ wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
    $ tar xzvf ruby-1.9.3-p0.tar.gz
    $ cd ruby-1.9.3-p0
    $ ./configure --prefix=/usr/local --enable-shared  --disable-install-doc \
      --with-opt-dir=/usr/local/lib
    $ make && make install


## See ya next time ...
That's it for now.  I'll continue in part 3.

[part 1](http://blog.irkeninvader.com/installing_the_server-part_1) | [part
2](http://blog.irkeninvader.com/installing_the_server-part_2)
