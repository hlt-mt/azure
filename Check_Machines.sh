### Usage example: check_azure_machine.sh FBK-NeuralMT

test $# -ge 1 || { echo 'ARGS: resourceGroup' ; exit 1 ; }

g=$1 ; shift

echo "ResourceGroup: $g"

log=/home/bertoldi/log_azure_$g

export PYTHONPATH=/nfsmnt/escher0/home/cattoni/__LOCAL_DATA__/code/python/MicrosoftAzureCLI/install/lib/python2.7/site-packages

az="python -m azure.cli"

date

for m in `$az vm list --output table --resource-group $g --query [*].[resourceGroup,name] |  grep "^$g" | awk '{print $2}'` ; do

status=`$az vm get-instance-view -n $m -g $g| python -m json.tool | grep -i status | grep VM | tr -d '",' | cut -f2 -d: | awk '{print $2}'`

if [ $status == "stopped" ] ; then    
echo "$m is $status only, deallocating" 
$az vm deallocate -n $m -g $g
else
echo "$m is $status, do nothing"
fi

done

echo
