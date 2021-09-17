free
memusage=$(free | awk 'NR==2{printf "%d", $3*100/$2}')
 
echo
echo "Memory usage is roughly $memusage%"
 
if [ $memusage -gt "98" ]; then
	echo "Critical state"
	exit 2
elif [ $memusage -gt "80" ]; then
	echo "Warning state"
	exit 1
else
	exit 0
fi
