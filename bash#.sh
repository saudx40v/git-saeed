#!/bin/bash

LOG_FILE="system_report.log"

# Function to display error messages and exit
handle_error() {
    local error_message="$1"
    echo "Error: $error_message" >&2
    exit 1
}

# Function to get user confirmation
confirm_action() {
    local prompt="$1"
    read -p "$prompt (y/n): " confirmation
    if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
        echo "Operation cancelled."
        exit 0
    fi
}

# Function to change file permissions
change_permissions() {
    local file="$1"
    local permissions="$2"
    chmod "$permissions" "$file" || handle_error "Failed to change permissions for $file"
    echo "Permissions for $file changed to $permissions."
}

# Function to change file ownership
change_ownership() {
    local file="$1"
    local owner="$2"
    local group="$3"
    chown "$owner:$group" "$file" || handle_error "Failed to change ownership for $file"
    echo "Ownership for $file changed to $owner:$group."
}

# Function to back up files
backup_file() {
    local file="$1"
    local backup_name="${file}.bak"
    cp "$file" "$backup_name" || handle_error "Failed to back up $file"
    echo "Backup created: $backup_name"
}

# Function to restore files
restore_file() {
    local backup="$1"
    local original_file="${backup%.bak}"
    cp "$backup" "$original_file" || handle_error "Failed to restore $original_file from $backup"
    echo "Restored $original_file from $backup"
}

# Function to display system information
display_system_info() {
    echo "Operating System: $(uname -s)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Current Date/Time: $(date)"
}

# Function to display CPU usage
display_cpu_usage() {
    echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')%"
}

# Function to display memory usage
display_memory_usage() {
    echo "Memory Usage:"
    free -h
}

# Function to display disk space usage
display_disk_space() {
    echo "Disk Space Usage:"
    df -h
}

# Function to generate system report
generate_report() {
    {
        echo "System Report - $(date)"
        display_system_info
        display_cpu_usage
        display_memory_usage
        display_disk_space
    } > "$LOG_FILE"
    echo "System report saved to $LOG_FILE"
}

# Main menu for user interaction
main_menu() {
    echo "Select an option:"
    echo "1. Change file permissions"
    echo "2. Change file ownership"
    echo "3. Backup file"
    echo "4. Restore file"
    echo "5. Display system information"
    echo "6. Display CPU usage"
    echo "7. Display memory usage"
    echo "8. Display disk space usage"
    echo "9. Generate system report"
    echo "10. Exit"

    read -p "Enter your choice [1-10]: " choice
    case "$choice" in
        1)
            read -p "Enter the file path: " file
            read -p "Enter the new permissions (e.g., 755): " permissions
            change_permissions "$file" "$permissions"
            ;;
        2)
            read -p "Enter the file path: " file
            read -p "Enter the new owner (e.g., user): " owner
            read -p "Enter the new group (e.g., group): " group
            change_ownership "$file" "$owner" "$group"
            ;;
        3)
            read -p "Enter the file path to back up: " file
            confirm_action "Are you sure you want to back up $file?"
            backup_file "$file"
            ;;
        4)
            read -p "Enter the backup file path: " backup
            confirm_action "Are you sure you want to restore from $backup?"
            restore_file "$backup"
            ;;
        5)
            display_system_info
            ;;
        6)
            display_cpu_usage
            ;;
        7)
            display_memory_usage
            ;;
        8)
            display_disk_space
            ;;
        9)
            generate_report
            ;;
        10)
            exit 0
            ;;
        *)
            echo "Invalid option. Please select a number between 1 and 10."
            ;;
    esac
}

# Run the main menu in a loop
while true; do
    main_menu
done

