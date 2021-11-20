#!/bin/bash
clear
alias kubectl='kubectl.exe'
alias minikube='minikube.exe'

echo "Hello Team!!!!"
sleep 1
echo "Starting a new deployment..."
sleep 1

#########################
#Namespace configuration
#########################
namespace=integration
echo "Checking namespace"

kubectl get namespace | grep $namespace
return=$?
if [ $return -eq 0 ]
    then
        echo "Removing old $namespace namespace"
        sleep 1
        kubectl delete namespace $namespace
        return1=$?
        if [ $return1 -eq 0 ]
            then
                echo "Namespace $namespace deleted"
                sleep 1
                echo "Creating a new namespace"
                kubectl create namespace $namespace
                return2=$?
                if [ $return2 -eq 0 ]
                    then
                        echo "Namespace $namespace created"
                        sleep 1
                    else
                        echo "Failed to create namespace $namespace"
                        exit $return2
                fi
            else
                echo "Failed to delete old $namespace namespace"
                exit $return1
        fi 
    else
        echo "Creating a new namespace"
        kubectl create namespace $namespace
        return2=$?
        if [ $return2 -eq 0 ]
            then
                echo "Namespace $namespace created"
                sleep 1
            else
                echo "Failed to create namespace $namespace"
                exit $return2
        fi
fi
#########################
#Backend deployment
#########################
echo "Deploying backend"
sleep 1

kubectl apply -f backend-deployment.yaml
return=$?
if [ $return -eq 0 ]
    then
        echo "Backend deployed successfull!"
        sleep 1
    else
        echo "Failed to deploy backend"
        exit $return
fi
#########################
#Backend service
#########################
echo "Deploying backend service..."
sleep 1

kubectl apply -f backend-service.yaml
return=$?
if [ $return -eq 0 ]
    then
        echo "Backend service deployed successfull!"
        sleep 1
    else
        echo "Failed to deploy backend service"
        exit $return
fi
#########################
#Frontend deployment
#########################
echo "Deploying frontend"
sleep 1

kubectl apply -f frontend-deployment.yaml
return=$?
if [ $return -eq 0 ]
    then
        echo "Frontend deployed successfull!"
        sleep 1
    else
        echo "Failed to deploy frontend"
        exit $return
fi
#########################
#Frontend service
#########################
echo "Deploying frontend service..."
sleep 1

kubectl apply -f frontend-service.yaml
return=$?
if [ $return -eq 0 ]
    then
        echo "Frontend service deployed successfull!"
        sleep 1
    else
        echo "Failed to deploy frontend service"
        exit $return
fi
nohup minikube.exe service frontend -n integration &
exit



