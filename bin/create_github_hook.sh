#!/bin/bash

hook_event="pull_request"

if [ -f "$1" ]
then
    echo "Reading answers file '$1'"
    . $1
else
    echo "No answers file passed."
fi

vars=( repo_user repo_name callback_url hook_event )
prompts=( "Repo Account Name" "Repo Name" "Callback URL" "Hook Event")

for (( i=0; i<${#vars[@]}; i++ ))
do
    read -p "${prompts[$i]} [${!vars[$i]}]: " input
    export ${vars[$i]}=${input:-${!vars[$i]}}
done

read -p "Login Name [$repo_user]:" auth_user
auth_user=${auth_user:-$repo_user}

if [ -z "$password" ]
then
    stty -echo
    read -p "Password: " password
    stty echo
fi

curl -u "$auth_user:$password" -d "{ \"name\": \"web\", \"events\": [ \"$hook_event\" ], \"active\": true, \"config\": { \"url\": \"$callback_url\" } }" https://api.github.com/repos/$repo_user/$repo_name/hooks

echo
echo "You may visit the following URL to administer hooks:"
echo
echo "  https://github.com/$repo_user/${repo_name}/admin/hooks"
echo
echo "Or, run the following command to examine your existing hooks:"
echo
echo "  curl -u "$auth_user:\<GITHUB_PASSWORD\>" https://api.github.com/repos/$repo_user/$repo_name/hooks"
echo
echo "For more info, see: http://developer.github.com/v3/repos/hooks/"
echo