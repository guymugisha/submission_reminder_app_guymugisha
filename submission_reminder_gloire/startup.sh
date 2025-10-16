
#!/bin/bash
if [ -f "./app/reminder.sh" ]; then
    ./app/reminder.sh
else
    echo "Failed to create reminder.sh not found in app/ directory"
exit 1
fi

