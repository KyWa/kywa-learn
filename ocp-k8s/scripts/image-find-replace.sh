#!/usr/bin/env bash

# This script will do a mass find and replace on all instances of "OFFENDING_THING" to the current Nexus instance of "NEW_THING"
# To do this en masse, you can get a list of namespaces like so:
#
# oc get ns -l foo=bar > namespace_list
#
# Once you have that list you can iterate through this script like so:
# for i in `cat namespace_list`;do oc project $i; ./find-replace-ocp-image.sh all;done

usage(){
  echo "Usage: $0 OBJECT_TO_PATCH"
  echo ""
  echo "  Options are:"
  echo "  - bc, buildconfig, buildconfigs"
  echo "  - dc, deploymentconfig, deploymentconfigs"
  echo "  - deploy, deployment, deployments"
  echo "  - is, imagestream, imagestreams"
  echo "  - all"
}

init(){
  NS=$(cat ~/.kube/config 2>/dev/null| grep -o '^current-context: [^/]*' | cut -d' ' -f2)
  echo "You are currently running against the Namespace: $NS"
  echo ""
  if [[ -e "${NS}" ]];then
    echo "Existing patched file for $NS, making a backup"
    mv $NS/patched $NS/patched.`date +%H_%M_%S__%d_%m_%y`
  else
    echo "No existing directory for $NS, creating new one"
    mkdir -p $NS
  fi
  echo "Are you sure you wish to continue? "
  read answer
  echo ""

  case $answer in
      [yY][eE][sS][|[yY])
          echo "Continuing on to modify objects in Namespace $NS"
          ;;
      [nN][oO]|[nN])
          echo "Exiting due to uncertainty"
          exit
          ;;
  esac
}
finish(){
  echo ""
  echo "Here are the objects that were modified in the Namespace: $NS"
  echo ""
  echo "---"
  cat $NS/patched
  echo ""
  echo "Finished resolving items in Namespace: $NS"
}

buildconfig_fix(){
  # Get JSON of each offending Deployment
  CHECK_BC=$(oc get bc -o json | jq -r '.items[] | select(.spec.strategy | to_entries[].value.from?.name) | .metadata.name')
  for i in $CHECK_BC;do
    BAD_BC=$(oc get bc -o json $i | jq -r 'select(.spec.strategy | to_entries[0].value.from.name | contains("OFFENDING_THING")) | .metadata.name')
    for i in $BAD_BC;do
      # Identify offending image
      IMG=$(oc get bc $i -o json | jq -r '.spec.strategy | to_entries[0].value.from.name')
      # Convert offending image
      NEW_IMG=$(echo $IMG | sed 's/OFFENDING_THING/NEW_THING/g')
      # Verify BC type for patch to work
      BC_TYPE=$(oc get bc -o json $i | jq -r '.spec.strategy | to_entries[0].key')
      # Patch the offending object
      oc patch bc $i -p '{"spec":{"strategy":{"'${BC_TYPE}'":{"from":{"name":"'${NEW_IMG}'"}}}}}' >> $NS/patched
    done
  done
}

deployment_fix(){
  # Get JSON of each offending Deployment
  BAD_DEP=$(oc get deploy -o json | jq -r '.items[] | select(.spec.template.spec.containers[].image | contains("OFFENDING_THING"))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name')
  for i in $BAD_DEP;do
    # Get each name of the offending containers that match
    CONTAINERS=$(oc get deploy $i -o json | jq -r '.spec.template.spec.containers[] | select(.image | contains("OFFENDING_THING")) .name')
    for x in $CONTAINERS;do
      # Get the image of the container against the name previously obtained
      IMG=$(oc get deploy $i -o json | jq -r --arg name $x '.spec.template.spec.containers[] | select(.name == $ARGS.named.name) .image')
      # Convert offending image
      NEW_IMG=$(echo $IMG | sed 's/OFFENDING_THING/NEW_THING/g')
      # Patch the offending object
      oc patch deploy $i -p '{"spec":{"template":{"spec":{"containers":[{"name":"'${x}'","image":"'${NEW_IMG}'"}]}}}}' >> $NS/patched
    done
  done
}

deploymentconfig_fix(){
  # Get JSON of each offending Deployment
  BAD_DEP=$(oc get deploymentconfig -o json | jq -r '.items[] | select(.spec.template.spec.containers[].image | contains("OFFENDING_THING"))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name')
  for i in $BAD_DEP;do
    # Get each name of the offending containers that match
    CONTAINERS=$(oc get deploymentconfig $i -o json | jq -r '.spec.template.spec.containers[] | select(.image | contains("OFFENDING_THING")) .name')
    for x in $CONTAINERS;do
      # Get the image of the container against the name previously obtained
      IMG=$(oc get deploymentconfig $i -o json | jq -r --arg name $x '.spec.template.spec.containers[] | select(.name == $ARGS.named.name) .image')
      # Convert offending image
      NEW_IMG=$(echo $IMG | sed 's/OFFENDING_THING/NEW_THING/g')
      # Patch the offending object
      oc patch deploymentconfig $i -p '{"spec":{"template":{"spec":{"containers":[{"name":"'${x}'","image":"'${NEW_IMG}'"}]}}}}' >> $NS/patched
    done
  done
}

imagestream_fix(){
  # Get JSON of each offending ImageStream
  BAD_IS=$(oc get is -o json | jq -r '.items[] | select(.spec | to_entries[].key | contains("tags"))' | jq -rs 'unique_by(.metadata.name)[] | .metadata.name')
  for i in $BAD_IS;do
    # Get each name of the offending images that match
    IMAGES=$(oc get is $i -o json | jq -r '.spec.tags[] | select(.from.name | contains("OFFENDING_THING")) .name')
    for x in $IMAGES;do
      # Create list for each ImageStream's containers that match
      IMG=$(oc get is $i -o json | jq -r --arg name $x '.spec.tags[] | select(.name == $ARGS.named.name) .from.name')
      if [[ ${IMG} == *"443"* ]];then
        # Convert offending image if it already has the Port listed
        NEW_IMG=$(echo $IMG | sed 's/OFFENDING_THING/NEW_THING/g')
        # Patch the offending object
        oc patch is $i -p '{"spec":{"tags":[{"name":"'${x}'","from":{"name":"'${NEW_IMG}'"}}]}}' >> $NS/patched
      else
        # Convert offending image if it does not have the port specified
        NEW_IMG=$(echo $IMG | sed 's/OFFENDING_THING/NEW_THING/g')
        # Patch the offending object
        oc patch is $i -p '{"spec":{"tags":[{"name":"'${x}'","from":{"name":"'${NEW_IMG}'"}}]}}' >> $NS/patched
      fi
    done
  done
}

case "$1" in
  all)
    init
    echo "Fixing all objects"
    echo ""
    buildconfig_fix
    deployment_fix
    deploymentconfig_fix
    imagestream_fix
    finish
    ;;
  buildconfig|buildconfigs|bc)
    init
    echo "Fixing BuildConfigs"
    echo ""
    buildconfig_fix
    finish
    ;;
  deployment|deployments|deploy|deploymentconfig|deploymentconfigs|dc)
    init
    echo "Fixing Deployments and DeploymentConfigs"
    echo ""
    deployment_fix
    deploymentconfig_fix
    finish
    ;;
  imagestreams|imagestream|is)
    init
    echo "Fixing ImageStreams"
    echo ""
    imagestream_fix
    finish
    ;;
  *)
    usage
    ;;
esac
