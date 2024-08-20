#!/usr/bin/env bash

## Get all namespaces with DCs
ns_list=`oc get dc -A | grep -v NAME | awk '{print $1}' | sort -u`

##### BEGIN FUNCTIONS
setup_workspace(){
  mkdir /tmp/$ns
  temp_clean="/tmp/$ns/temp_converted.json"
  oc project $ns
  all_ns_dcs=`oc get dc -o json | jq -r '.items[]'`
}

get_vars(){
  get_selectors=$(echo $current_dc | jq -r '.spec.selector')
  get_triggers=$(echo $current_dc | jq '.spec.triggers[] | select(.type == "ImageChange")')
}

cleanup_dc_metadata(){
  echo $current_dc | jq 'del(.metadata.annotations."kubectl.kubernetes.io/last-applied-configuration"?, .metadata.creationTimestamp, .metadata.generation, .metadata.resourceVersion, .metadata.uid, .spec.selector[], .spec.strategy, .spec.triggers, .spec.test, .status)' | jq '.metadata.annotations."image.openshift.io/triggers" = "REPLACE"' > $temp_clean
  sed -i 's/"apiVersion": "apps.openshift.io\/v1"/"apiVersion": "apps\/v1"/g'  $temp_clean
  sed -i 's/"kind": "DeploymentConfig"/"kind": "Deployment"/g' $temp_clean
}

selector_cleanup(){
  cat $temp_clean | jq --argjson keys "$get_selectors" '.spec.selector.matchLabels = $ARGS.named.keys' > $converted
}

image_trigger(){
  template='[{\\\"from\\\":{\\\"kind\\\":\\\"KIND\\\",\\\"name\\\":\\\"NAME\\\",\\\"namespace\\\":\\\"NS\\\"},\\\"fieldPath\\\":\\\"spec.template.spec.containers[?(@.name==\\\"CONTAINER\\\")].image\\\",\\\"pause\\\":\\\"false\\\"}]'
  multi_template='{\\\"from\\\":{\\\"kind\\\":\\\"KIND\\\",\\\"name\\\":\\\"NAME\\\",\\\"namespace\\\":\\\"NS\\\"},\\\"fieldPath\\\":\\\"spec.template.spec.containers[?(@.name==\\\"CONTAINER\\\")].image\\\",\\\"pause\\\":\\\"false\\\"}'

  triggers=`echo $get_triggers | jq '.imageChangeParams.containerNames[]' | sed 's/"//g'`
  count=`echo $triggers | wc -w`
  last_item=`echo $triggers | awk '{print $NF}'`
  multi=""

  if [[ ${count} > 1 ]];then
    for i in $triggers;do
      iterate_trigger=`echo $current_dc | jq '.spec.triggers[] | select(.type == "ImageChange")' | jq --arg name $i 'select(.imageChangeParams.containerNames[] | contains($ARGS.named.name))'`
      kind=`echo $iterate_trigger | jq '.imageChangeParams.from.kind' | sed 's/"//g'`
      img_name=`echo $iterate_trigger | jq '.imageChangeParams.from.name' | sed 's/"//g'`
      ns_name=`echo $iterate_trigger | jq '.imageChangeParams.from.namespace' | sed 's/"//g'`
      cont_name=$i
      core=`echo $multi_template | sed 's/KIND/'$kind'/g' | sed 's/NAME/'$img_name'/g' | sed 's/NS/'$ns_name'/g' | sed 's/CONTAINER/'$cont_name'/g'`
      if [[ "${i}" == "${last_item}" ]];then
        multi="${multi}${core}"
      else
        multi="${multi}${core},"
      fi
  
    done
    complete_trigger="[${multi}]"
    sed -i -e 's/REPLACE/'$complete_trigger'/g' $temp_clean
  else
    for i in $triggers;do
      iterate_trigger=`echo $current_dc | jq '.spec.triggers[] | select(.type == "ImageChange")' | jq --arg name $i 'select(.imageChangeParams.containerNames[] | contains($ARGS.named.name))'`
      kind=`echo $iterate_trigger | jq '.imageChangeParams.from.kind' | sed 's/"//g'`
      img_name=`echo $iterate_trigger | jq '.imageChangeParams.from.name' | sed 's/"//g'`
      ns_name=`echo $iterate_trigger | jq '.imageChangeParams.from.namespace' | sed 's/"//g'`
      cont_name=$i
      complete_trigger=`echo $template | sed 's/KIND/'$kind'/g' | sed 's/NAME/'$img_name'/g' | sed 's/NS/'$ns_name'/g' | sed 's/CONTAINER/'$cont_name'/g'`
      sed -i -e 's/REPLACE/'$complete_trigger'/g' $temp_clean
    done
  fi

}

### "Main"
for ns in $ns_list;do
  mkdir /tmp/$ns
  setup_workspace
  for dc in `echo $all_ns_dcs | jq -r '.metadata.name'`;do
    current_dc=`echo $all_ns_dcs | jq --arg name $dc 'select(.metadata.name == $ARGS.named.name)'`
    converted="/tmp/$ns/$dc-converted.json"
    get_vars $dc
    cleanup_dc_metadata $dc
    image_trigger
    selector_cleanup
    rm $temp_clean
  done
done
