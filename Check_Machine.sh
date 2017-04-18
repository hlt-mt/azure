### Usage example: check_azure_machine.sh FBK-NeuralMT

test $# -ge 1 || { echo 'ARGS: resourceGroup' ; exit 1 ; }

g=$1 ; shift

echo "ResourceGroup: $g"

log=/home/bertoldi/log_azure_$g

export PATH=/nfsmnt/escher0/home/cattoni/__LOCAL_DATA__/Projects/HLT/cloud/MicrosoftAzure/CLI/HIGHLEVEL:${PATH}

date
for m in `az vm list --output table --resource-group $g --query [*].[resourceGroup,name] |  grep "^$g" | awk '{print $2}'` ; do
status=`AZ_get_status.sh $m $g`

if [ $status == "stopped" ] ; then    
echo "$m is $status only, deallocating" 
AZ_stop.sh $m $g
else
echo "$m is $status, do nothing"
fi

done

echo
