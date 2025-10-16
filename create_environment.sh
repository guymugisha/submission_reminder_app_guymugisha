#!/bin/bash
#creating submission reinder apps for students

#ask for the user input name to create dir
read -p "Enter your name: " name
mkdir -p submission_reminder_$name

appdir="submission_reminder_$name"
#create directories
mkdir -p "$appdir/app"
mkdir -p "$appdir/modules"
mkdir -p "$appdir/assets"
mkdir -p "$appdir/config"

#create the files in their assigned directories

echo '# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2' > $appdir/config/config.env

echo "student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
 " > $appdir/assets/submissions.txt

echo '#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}' > $appdir/modules/functions.sh

#reminder script 
echo '#!/bin/bash

# Source environment variables and help
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"


# printing the remaining time
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file' > $appdir/app/reminder.sh

#the startup script 
echo '
#!/bin/bash
if [ -f "./app/reminder.sh" ]; then
    ./app/reminder.sh
else
    echo "Failed to create reminder.sh not found in app/ directory"
exit 1
fi
' > $appdir/startup.sh
#make all scripts excecutable
chmod +x $appdir/app/reminder.sh
chmod +x $appdir/modules/functions.sh
chmod +x $appdir/assets/submissions.txt
chmod +x $appdir/startup.sh
