#!/bin/bash  
  
# Read the user input   
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
echo "Would you like to see the top level metadata items about the instance "  
read response
if [[ "$response" == "yes"]]; then
    curl -H "Accept: application/json" "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/
else
    echo "Please proceed to enter further details "
fi
echo "Would you like to know about more details!!!, please enter the meta data you are looking for"
read first_key
curl -H "Accept: application/json" "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/${first_key}
echo "If you would like to get further details, please enter key value"
read second_key
curl -H "Accept: application/json" "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/${first_key}/${second_key}


