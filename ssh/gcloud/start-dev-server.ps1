# Configuration
# Change these values to reflect your environment
$INITIAL_SLEEP_DURATION=30 # Do not have a workaround to check if ssh is online
$MAX_ITERATION=5
$SLEEP_DURATION=5

# Arguments passed from SSH client
$INSTANCE_NAME = $args[0]

$STATUS=gcloud compute instances describe $INSTANCE_NAME --format="get(status)"
if($STATUS -eq 'RUNNING'){
    # Pass
}
else{
    # Instance is offline - Start the instance
    gcloud compute instances start $INSTANCE_NAME

    Start-Sleep $INITIAL_SLEEP_DURATION

    $COUNT=0

    while ( ${COUNT} -le ${MAX_ITERATION} ){
        $STATUS=gcloud compute instances describe $INSTANCE_NAME --format="get(status)"
        $result =  gcloud compute instances describe $INSTANCE_NAME 

        if ($STATUS -eq "RUNNING"){
            break
        }elseif($COUNT -eq $MAX_ITERATION){
            exit 1
        }
        else{
            $COUNT = $COUNT + 1
            Start-Sleep $SLEEP_DURATION
        }

    }
}
# start ssh proxy
gcloud beta compute start-iap-tunnel $INSTANCE_NAME 22 --listen-on-stdin
