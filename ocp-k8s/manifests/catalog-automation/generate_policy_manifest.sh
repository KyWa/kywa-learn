#!/usr/bin/env bash

## VARS
digestfile="imageDigestMirrorSet.yaml"
digest_target=`grep name $digestfile | awk '{print $2}' | cut -d "-" -f 1`
policy_file_template="policy-digest-$digest_target.yaml"
cp policy-digest-template.yaml $policy_file_template
sed -i "s/TYPE/$digest_target/g" $policy_file_template

# Sanity check and pruning
check_yaml_start=`head -n1 $digestfile`
if [[ ${check_yaml_start} == "---" ]];then
  sed -i 's/---//g' $digestfile
fi

# Create policy manifest
while IFS="" read line;do
  sed "s/^/\ \ \ \ \ \ \ \ \ \ \ \ /g" >> $policy_file_template
done <$digestfile
