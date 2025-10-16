#!/bin/bash

read -p "Enter your name: " name

name=$(echo "$name" | tr '[:upper:]' '[:lower:]')

if [ -z "$name" ]; then
    echo "name can't be empty"
    exit 1
fi

if [[ ! $name =~ ^[a-z]+$ ]]; then
    echo "name is invalid"
    exit 1
fi

dir="submission_reminder_$name"
sub_file="$dir/assets/submissions.txt"
conf_file="$dir/config/config.env"



#check of dir exists
if [ ! -d "$dir" ]; then
    echo "Directory does'nt exist"
    exit 1
fi

read -p "Enter assignment name: " assignment
read -p "Enter submission days remaining: " days

if [[ -z $assignment ]]; then
    echo "assignment is empty"
    exit 1
fi
if ! [[ "$days" =~ ^[0-9]+$ ]]; then
    echo "days are empty"
    exit 1
fi

if [[ ! $assignment =~ ^[a-zA-Z0-9\ ]+$ ]]; then
    echo "assignment is not valid"
    exit 1
fi

# check if assignment already exits
matched_assign=$(grep -i ", *$assignment," "$sub_file" | awk -F',' '{print $2}' | head -n1 | xargs)
if [[ -z $matched_assign ]]; then
    echo "Assignment '$assignment' is not available in submission file"
    exit 1
fi

#changing config file 
cat <<EOF > $conf_file
ASSIGNMENT="$matched_assign"
DAYS_REMAINING=$days
EOF

read -p "Do you want to run the app? (y/n): " runApp

if [[ $runApp =~ ^[Yy]$ ]]; then
   echo "The app is running..."
   cd "$dir"
   ./startup.sh
else
   echo "Sorry, You may run the app later by going to the directory '$dir' and execute './startup.sh'"
fi
