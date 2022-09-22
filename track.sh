#!/bin/bash  

track(){
mkdir -p ~/.local/share

touch ~/.local/share/.timer_logfile

#making directories and file

env_var=$(cat ~/.bashrc | grep "LOGFILE")


# check if the ev is set from before and doing that if not
if [  -z "${env_var}" ]; then
	echo "Not found LOGFILE"
	echo "export LOGFILE=~/.local/share/.timer_logfile" >> ~/.bashrc 
else
	echo "LOGFILE is alleready set"
fi
#getting last item in the list e.g. the last one to be placed in the file
last_label="$(cut -f 1-5 -d " " ${LOGFILE} | nl | sort -nr | head -n1)"
status_msg="$(cut -f 1-7 -d " " ${LOGFILE} | tail -n 2)" #status msg

if [ "$#" -gt 2 ]; then
    echo "More than two arguments provided: <start/stop/status> opt<label> "
else
	#echo "Hello"
	if [ "$1" = "start" ]; then

		if [[ "$last_label" == *"LABEL"* ]]; then
        		echo "ERROR: a task is aleraedy running"
		else 
        		if [[ "$last_label" == *"END"* ]]; then #if no running tasks, starting the task
					echo "START $(date)" >> ${LOGFILE}
					echo "LABEL this is task ${2}" >> ${LOGFILE} # appending to log file
				else
					echo "START $(date)" >> ${LOGFILE}
					echo "LABEL this is task ${2}" >> ${LOGFILE}
				fi
		fi
	elif [ "$1" = "stop" ]; then # Stopping if running othervise error msg
		if [[ "$last_label" == *"LABEL"* ]]; then
			echo "END $(date)" >> ${LOGFILE} # appending to the log file
		elif [[ "$last_label" == *"END"* ]]; then
				echo "ERROR: no running task, please start one."
		fi
	elif [ "$1" = "status" ]; then #giving status update if a task is running
		if [[ "$last_label" == *"LABEL"* ]]; then
		echo "Currently tracking:"
		echo ${status_msg}
		else 
		echo "No running tasks at this moment."
		fi
		elif [ "$1" = "log" ]; then

    num_of_entries=$(grep "END" ${LOGFILE} | cut -f 2-8 -d " " | wc -l) #calculating muber of entries with "END" keyword (meaning done tasks)
    num_of_entries=$(($num_of_entries+$num_of_entries)) #number of entries for the loop is double  because counter is increased with 2 each iter.
    #echo $all_s_and_e
    
    counter=1 #counter for the entries (start/end)
    count_label=1 #counter for the label (tasks)
    #datum=$(grep "START\|END" ${LOGFILE} | cut -f 2-8 -d " ")
    while [ $counter -le $num_of_entries ]
    do
    proc=$(grep "START\|END" ${LOGFILE} | cut -f 1-8 -d " " | tail -n +$counter | head -n 2) #get all start end entries but start at first, show 2 lins
	                                                                                        #however, next iter will show entries 2 lines down e.g we are moving down
    
    start=$(echo $proc | grep "START" | cut -f 2-7 -d " ") #get date
    end=$(echo $proc | grep "END" | cut -f 9-14 -d " ") #get date
    
    start_sec=$(date -d "$start" +"%s") #convert
    end_sec=$(date -d "$end" +"%s") #convert

    secs=$(($end_sec-$start_sec))
    
    label=$(grep "LABEL" ${LOGFILE} | cut -f 4 -d " " | tail -n +$count_label | head -n 1) #same logic as for start/end showing label entries
	#line for line going down with each iter
    #echo $label
    
    printf '%s %dd %dh:%dm:%ds\n' ${label}: $(($secs/86400)) $(($secs%86400/3600)) $(($secs%3600/60)) $(($secs%60))
    ((counter=$counter+2))
    ((count_label=$count_label+1))
    done
    echo All done
	fi
	fi

}
