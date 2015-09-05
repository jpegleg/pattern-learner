#!/bin/sh
# Install pattern learner. The default pattern is Deny.
which wget
if [ $? -eq 0 ]; then
  echo "Found wget, which we use to pull back down data from the web that gets deleted."
else
  echo "Please install wget before running this script again."
  exit 1
fi
if [ -f /usr/local/bin/sec.pl ] ; then
  echo "Found /usr/local/bin/sec.pl"
else
  echo "Installing /usr/local/bin/sec.pl"
  wget http:/hyalitepress.com/sec
  if [ whoami == root ]; then
    echo "Running as root."
    cp sec /usr/local/bin/sec.pl
    chmod +x /usr/local/bin/sec.pl
  else
    echo "Running as $(whoami)";
  cp sec /usr/local/bin/sec.pl
  if [ $? -eq 0 ]; then
    echo "Configured sec as $(whoami)"
  else
    echo "Failed to configure sec as $(whoami).... trying sudo."
    sudo cp sec /usr/local/bin/sec.pl
    if [ $? -eq 0 ]; then
    echo "Configured sec as $(whoami) with sudo."
    else
    echo "Could not install sec.pl, please run with permissions to write to /usr/local/bin"
    fi
    fi
  fi
fi
echo "Alright, now that we have the dependancies,  moving on to the hist-event-reaction configuration...."
if [ whoami == root ]; then
    echo "Running as root."
    echo "Setting up directories..."
    mkdir -p /var/tmp/learner
    echo "Looking for learner.cfg"
    ls learner.cfg
    cp learner.cfg /etc/
    echo "Configured learner.cfg"
  else
    echo "Running as $(whoami)";
    echo "Setting up directories..."
    mkdir -p /var/tmp/learner
    echo "Looking for learner.cfg"
    ls learner.cfg
    sudo cp learner.cfg /etc/
    echo "Configured learner.cfg"

    if [ $? -eq 0 ]; then
      echo "Set up directories as $(whoami)"
    else
      echo "Set up directories as $(whoami)"
    else
      echo "Couldn't set up directory /var/tmp/learner as $(whoami)."
      echo "Trying sudo..."
      sudo mkdir -p /var/tmp/learner/
      if [ $? -eq 0 ]; then
      echo "Set up directory as $(whoami) with sudo."
      else
      echo "Could not set up directory, please run with elevated permissions."
      fi
    fi
 fi
echo "Looking for learner-watcher.cfg"
ls learner-watcher.cfg
cp learner-watcher.cfg /etc/
if [ $? -eq 0 ]; then
  echo "Located and install learner-watcher.cfg  as $(whoami)"
else
  echo "Failed to install learner-watcher.cfg  as $(whoami).... trying sudo."
  sudo cp learner-watcher.cfg /etc/
  if [ $? -eq 0 ]; then
    echo "Found and installed learner-watcher.cfg  as $(whoami) with sudo."
  else
    echo "Could not install learner-watcher.cfg, please run with permissions to write to /etc/"
  fi
fi
echo "Daemonizing"
if [ whoami == root ]; then
sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner-child.log --debug=6 --detach
sec.pl --input=/var/log/new-deny.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --debug=6 --detach
  echo "Daemonized learner-watcher with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner-watcher.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
  echo "Daemonized learner with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
else
sudo sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner-child.log --debug=6 --detach
sudo sec.pl --input=/var/log/new-deny.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --debug=6 --detach
  echo "Daemonized learner-watcher with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner-watcher.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
  echo "Daemonized learner with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
fi
