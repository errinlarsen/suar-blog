title: Making it all work
date: 2011-12-31

## This article needs some serious clean-up!
For now, this will just hold all the histories of what was done

## Deployer
    1  ls
    2  mkdir ~/.ssh/
    3  chmod 700 .ssh
    4  ssh-keygen -f ~/.ssh/id_rsa.github
    5  vim .ssh/config
    6  ssh git@github.com
    7  cat .ssh/id_rsa.github.pub 
    8  ssh git@github.com
    9  git clone git@github.com:errinlarsen/suar-blog.git
   10  cd suar-blog/
   11  git status
   12  cat Gemfile
   13  vim Gemfile
   14  git fetch
   15  git pull origin master
   16  gem install bundler
   17  exit
   18  cd suar-blog/
   19  bundle install --deployment
   20  rackup --help
   21  bundle exec rackup --help
   22  rackup -D -p 80
   23  bundle exec rackup -D -p 80
   24  cat lib/blog.rb 
   25  cat Gemfile
   26  vim lib/blog.rb 
   27  rackup -p 80
   28  bundle exec rackup -p 80
   29  cat config.ru 
   30  bundle exec rackup
   31  bundle exec rackup -H 50.56.226.92 -p 80 -E production
   32  bundle exec rackup -o 50.56.226.92 -p 80 -E production
   33  iptables
   34  sudo lsof -i  :80
   35  exit
   36  history > /tmp/deployer.history
## ELarsen
    1  sudo su -
    2  exit
    3  mkdir .ssh
    4  chmod 700 .ssh
    5  ls
    6  exit
    7  ls
    8  which apt-get
    9  ls -la /usr/bin/apt*
   10  sudo apt-cache find ruby
   11  sudo apt-cache search ruby
   12  sudo apt-cache info ruby1.9
   13  sudo apt-cache help
   14  sudo apt-cache showpkg ruby1.9
   15  sudo su - 
   16  sudo su - deployer
   17  sudo gem install bundler
   18  sudo su - 
   19  sudo su - deployer
   20  cd ~deployer/suar-blog/
   21  bundle exec rackup -o 50.56.226.92 -p 80 -E production
   22  sudo lsof -i  :80
   23  netstat -ra
   24  netstat -a
   25  sudo bundle exec rackup -o 50.56.226.92 -p 80 -E production
   26  cd ..
   27  cd suar-blog/
   28  sudo bundle exec rackup -D -o 50.56.226.92 -p 80 -E production
   29  git log
   30  git pull
   31  sudo git pull
   32  sudo vim /etc/sudoers
   33  ps aux
   34  man git-pull
   35  man git
   36  sudo vim ~root/.ssh/config
   37  sudo git pull
   38  git diff lib/blog.rb 
   39  git status
   40  git checkout --
   41  sudo git checkout --
   42  history | grep rackup
   43  sudo bundle exec rackup -D -o 50.56.226.92 -p 80 -E production
   44  git log
   45  git log
   46  man rackup
   47  bundle exec rackup --help
   48  ls -la
   49  ls /tmp
   50  ls /var
   51  ls /var/log
   52  ls -latr /var/log
   53  date
   54  cd ..
   55  ls
   56  exit
   57  sudo su -
   58  exit
   59  history > elarsen.history
## Root
    1  exit
    2  which ruby
    3  useradd elarsen
    4  passwd elarsen
    5  which sudo
    6  vim /etc/sudoers
    7  vim /etc/passwd
    8  vim /etc/group
    9  su - elarsen
   10  vim /etc/passwd
   11  which zsh
   12  which bash
   13  vim /etc/passwd
   14  cd /home
   15  ls
   16  cat /etc/skel
   17  ls /etc/skel
   18  mkdir elarsen
   19  chown elarsen:elarsen elarsen
   20  ls -la
   21  cd elarsen
   22  cd
   23  su - elarsen
   24  exit
   25  pwd
   26  wget http://pyyaml.org/download/libyaml/yaml-0.1.4.tar.gz
   27  tar xzvf yaml-0.1.4.tar.gz 
   28  cd yaml-0.1.4
   29  ./configure --prefix=/usr/local
   30  apt-get install build-essentials
   31  apt-get install build-essential
   32  apt-get install build-essential --fix-missing
   33  apt-get update
   34  apt-get install build-essential
   35  cd ..
   36  ls
   37  ls /usr/local
   38  ls
   39  mv -?
   40  mv --help
   41  mv yaml-0.1.4* /usr/local/src
   42  cd /usr/local/src
   43  ls
   44  cd yaml-0.1.4
   45  apt-get install git-core
   46  cd yaml-0.1.pc.in 
   47  ls
   48  ./configure 
   49  make && make install
   50  cd ..
   51  wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p0.tar.gz
   52  tar xzvf ruby-1.9.3-p0.tar.gz 
   53  cd ruby-1.9.3-p0
   54  ./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
   55  make && make install
   56  ruby --version
   57  cat ~/.bashrc
   58  which git
   59  gem list
   60  useradd deployer
   61  mkdir /home/deployer
   62  chown deployer:deployer deployer
   63  chown deployer:deployer /home/deployer
   64  vim /etc/passwd
   65  vim /etc/group
   66  exit
   67  cd /usr/local/src
   68  make --help
   69  make clean
   70  cat Make
   71  cd ruby-1.9.3-p0
   72  ls
   73  cat Makefile
   74  make clean
   75  sudo apt-get install build-essential bison openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3 libxml2-dev autoconf
   76  history | grep configure
   77  ./configure --prefix=/usr/local --enable-shared --disable-install-doc --with-opt-dir=/usr/local/lib
   78  make && make install
   79  gem install bundler
   80  exit
   81  ls
   82  ls /tmp
   83  ps aux | grep bundle
   84  kill -9 1129
   85  cd ~deployer/
   86  cd suar-blog/
   87  bundle exec rackup -o 
   88  bundle exec rackup -o 50.56.226.92 -p 80 -E production
   89  git log
   90  git pull
   91  git checkout --
   92  bundle exec rackup -o 50.56.226.92 -p 80 -E production
   93  git log
   94  git pull
   95  git checkout .
   96  git status
   97  bundle exec rackup -o 50.56.226.92 -p 80 -E production
   98  bundle install --deployment
   99  git status
  100  bundle exec rackup -o 50.56.226.92 -p 80 -E production
  101  git pull
  102  bundle exec rackup -o 50.56.226.92 -p 80 -E production
  103  git pull
  104  git log
  105  bundle exec rackup -o 50.56.226.92 -p 80 -E production
  106  bundle exec rackup -o 50.56.226.92 -p 80 -E production -D
  107  exit
  108  history > ~elarsen/root.history
