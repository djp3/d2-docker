#!/usr/bin/bash
#Set up so that the docker container will cleanly shutdown mono
_term() {
  echo "launch.sh caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

#Set up the scripts 
cat configure.exp | envsubst > configure_go.exp
cat first_run.exp | envsubst > first_run_go.exp
#cat later_run.exp | envsubst > later_run_go.exp

#Wait for the database to come up
wait-for-it -q db:3306 -t 60 

if [ $? -eq 0 ]; then
  cd /root/diva-r09110/bin
  if [ ! -f "../../launch/is_configured.txt" ]; then
  	expect ../../launch/configure_go.exp
	touch ../../launch/is_configured.txt

	# Add custom set up
	echo ";; djp3:  Changes from DivaPrefences.ini" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "[DataSnapshot]" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "    DATA_SRV_MISearch=\"\"" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "[XEngine]" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "    AppDomainLoading = false" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "" >> /root/diva-r09110/bin/config-include/MyWorld.ini
	echo "    ThreadStackSize = 524288" >> /root/diva-r09110/bin/config-include/MyWorld.ini

  	echo "Configured world"
  else
  	echo "World was already configured"
  fi
  if [ ! -f "../../launch/has_first_run.txt" ]; then
  	expect ../../launch/first_run_go.exp
	touch ../../launch/has_first_run.txt
  	echo "First run complete"
  else
  	echo "First run already complete"
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
