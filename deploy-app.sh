#!/bin/bash
#By Francisco Neto <netoralves@gmail.com>
#========================== MICROSERVICE - SPRING BOOT ADMIN =======================================
#CONFIG-SERVER
app_name="admin-server"
project_name="config-server"
#===================================================================================================

# VARS
git_branches="master"
workspace="/tmp"

#=============================================================================================

#1. CLONE/PULL DO REPO GIT
if [ -d "$workspace/$app_name" ]; then
	cd $workspace/$app_name && git fetch && git checkout $git_branches && git pull
else
	git clone --single-branch -b $git_branches http://gitlab.saneago.com.br/saneago/suporte/ti/plataforma/admin-server.git $workspace/$app_name
fi

#2. SOURCE COMPILE
#MAVEN
#echo "cd $workspace/$app_name; mvn clean install"
cd $workspace/$app_name; mvn clean install

#3. CHANGE PROJECT (SAME BRANCH NAME)
oc project $project_name

#4. CREATE THE BUILD
oc new-build --binary --name=$app_name -l app=$app_name

#5. START THE BUILD WITH WORKDIR APP
#oc start-build $app_name --from-dir="$workspace/$app_name" --follow
oc start-build $app_name --from-dir="." --follow

#6. START THE CONTAINER
oc new-app $app_name -l app=$app_name

#7. CREATE THE SVC TO POD ACCESS
oc create service clusterip $app_name --tcp=8080:8080

#8.EXPOSE THE SVC TO EXTERNAL ACCESS
oc expose svc $app_name
