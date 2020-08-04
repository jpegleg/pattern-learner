#!/bin/sh
# Install pattern learner.

echo "Running as $(whoami)";
echo "Setting up directories..."
mkdir -p /var/tmp/learner
echo "Copying pattern-learner to /usr/local/bin"
cp ./pattern-learner /usr/local/bin/ || exit 1
echo "Copying pattern-sorter to /usr/local/bin"
cp ./pattern-sorter /usr/local/bin/ || exit 1
echo "Looking for learner.cfg"
ls learner.cfg || exit 1
cp learner.cfg /etc/ || exit 1
echo "Configured learner.cfg"
ls learner-watcher.cfg || exit 1
cp learner-watcher.cfg /etc/ || exit 1
if [ $? -eq 0 ]; then
  echo "Located and install learner-watcher.cfg  as $(whoami)"
else
  echo "Failed to install learner-watcher.cfg  as $(whoami).... trying sudo." && exit 1
fi
echo "Daemonizing"
if [ whoami == root ]; then
sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner-child.log --debug=6 --detach
sec.pl --input=/var/log/new-inp.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --debug=6 --detach
  echo "Daemonized learner-watcher with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner-watcher.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
  echo "Daemonized learner with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
else
sudo sec.pl --input=/var/log/net.log --conf=/etc/learner.cfg --log=/var/tmp/learner/learner-child.log --debug=6 --detach
sudo sec.pl --input=/var/log/new-inp.log --conf=/etc/learner-watcher.cfg --log=/var/tmp/learner/learner-watcher.log --debug=6 --detach
  echo "Daemonized learner-watcher with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner-watcher.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
  echo "Daemonized learner with the pid of:";
  ps -ef | grep "log=/var/tmp/learner/learner.log" | grep -v grep | awk '{print $2}' | tee /var/run/hist-event-reaction.pid
fi

~   
