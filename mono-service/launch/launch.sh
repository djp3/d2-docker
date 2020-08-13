#!/usr/bin/bash
#Set up so that the docker container will cleanly shutdown mono
_term() {
  echo "launch.sh caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

#Set up the scripts 
cat /root/launch/configure.exp | envsubst > /root/launch/configure_go.exp
cat /root/launch/first_run.exp | envsubst > /root/launch/first_run_go.exp
cat /root/launch/first_run_with_Universal_Campus.exp | envsubst > /root/launch/first_run_with_Universal_Campus_go.exp

#Wait for the database to come up
wait-for-it -q db:3306 -t 60 

if [ $? -eq 0 ]; then
  cd /root/diva-r09110/bin
  if [ ! -f "/root/launch/is_configured.txt" ]; then
  	expect /root/launch/configure_go.exp
	touch /root/launch/is_configured.txt

	# Add custom set up
	cat /root/launch/MyWorldAddendum.txt >> /root/diva-r09110/bin/config-include/MyWorld.ini
	cat /root/launch/VivoxAddendum.txt >> /root/diva-r09110/bin/config-include/MyWorld.ini

  	echo "Configured world"
  else
  	echo "World was already configured"
  fi
  if [ ! -f "/root/launch/has_first_run.txt" ]; then
	if [ $DP_UNIVERSAL_CAMPUS = "true" ]; then
  	  expect /root/launch/first_run_with_Universal_Campus_go.exp
  	  echo "First run installed Universal Campus"
	else
  	  expect /root/launch/first_run_go.exp
  	  echo "First run did not install Universal Campus"
	fi
	touch /root/launch/has_first_run.txt
  	echo "First run complete"
  else
  	echo "First run unnecessary - already complete"
  fi

  #expect ../../launch/later_run_go.exp &
  #child=$!
  #This enables us to pass on SIGTERM to expect
  #wait "$child"

  echo "OpenSim	run complete"
  echo "Launch script complete"
  tail -f /dev/null
  exit 0
else
  for i in {00..10};do echo ;done
  echo "Database did not spin up in 60 seconds"
  echo "Launch script failed"
  exit 1
fi
