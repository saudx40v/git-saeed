#!/bin/bash

# Function to display system information
display_system_info() {
    echo "System Information:"
    echo "Operating System: $(uname -s)"
    echo "Hostname: $(hostname)"
    echo "Uptime: $(uptime -p)"
    echo "Current Date/Time: $(date)"
    echo
}

# Function to display CPU usage
display_cpu_usage() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "CPU Usage: " 100 - $1 "%"}'
    echo
}

# Function to display memory usage
display_memory_usage() {
    echo "Memory Usage:"
    free -h | grep Mem | awk '{print "Total: " $2 ", Used: " $3 ", Free: " $4}'
    echo
}

# Function to display disk space usage
display_disk_space() {
    echo "Disk Space Usage:"
    df -h | grep '^/dev'
    echo
}

# Function to change file permissions
change_permissions() {
    read -p "Enter the file/directory path: " path
    if [ -e "$path" ]; then
        read -p "Enter the new permissions (e.g., 755): " permissions
        chmod "$permissions" "$path" && echo "Permissions changed successfully." || echo "Failed to change permissions."
    else
        echo "File/Directory does not exist."
    fi
}

# Function to change file ownership
change_ownership() {
    read -p "Enter the file/directory path: " path
    if [ -e "$path" ]; then
        read -p "Enter the new owner (e.g., user): " owner
        read -p "Enter the new group (e.g., group): " group
        chown "$owner":"$group" "$path" && echo "Ownership changed successfully." || echo "Failed to change ownership."
    else
        echo "File/Directory does not exist."
    fi
}

# Function to backup files
backup_files() {
    read -p "Enter the file/directory to backup: " source
    if [ -e "$source" ]; then
        read -p "Enter the backup file name (e.g., backup.tar.gz): " backup
        tar -czf "$backup" "$source" && echo "Backup created successfully." || echo "Failed to create backup."
    else
        echo "File/Directory does not exist."
    fi
}

# Function to restore files
restore_files() {
    read -p "Enter the backup file to restore from: " backup
    if [ -f "$backup" ]; then
        read -p "Enter the destination directory: " destination
        mkdir -p "$destination"
        tar -xzf "$backup" -C "$destination" && echo "Restore completed successfully." || echo "Failed to restore from backup."
    else
        echo "Backup file does not exist."
    fi
}

# Function to delete a file/directory with confirmation
delete_file() {
    read -p "Enter the file/directory path to delete: " path
    if [ -e "$path" ]; then
        read -p "Are you sure you want to delete '$path'? (y/n): " confirm
        if [ "$confirm" == "y" ]; then
            rm -rf "$path" && echo "Deleted successfully." || echo "Failed to delete."
        else
            echo "Deletion canceled."
        fi
    else
        echo "File/Directory does not exist."
    fi
}

# Function to rename a file/directory with confirmation
rename_file() {
    read -p "Enter the current file/directory path: " old_name
    if [ -e "$old_name" ]; then
        read -p "Enter the new file/directory path: " new_name
        read -p "Are you sure you want to rename '$old_name' to '$new_name'? (y/n): " confirm
        if [ "$confirm" == "y" ]; then
            mv "$old_name" "$new_name" && echo "Renamed successfully." || echo "Failed to rename."
        else
            echo "Renaming canceled."
        fi
    else
        echo "File/Directory does not exist."
    fi
}

# Function to generate a report of system metrics
generate_report() {
    report_file="system_report_$(date +%F_%T).txt"
    {
        echo "System Report - $(date)"
        echo
        display_system_info
        display_cpu_usage
        display_memory_usage
        display_disk_space
    } > "$report_file"
    echo "Report generated: $report_file"
}

# Main menu function
main_menu() {
    PS3="Select an option: "
    options=("System Monitoring" "File Management" "Backup/Restore" "Generate Report" "Exit")
    select opt in "${options[@]}"; do
        case $opt in
            "System Monitoring")
                PS3="Select a monitoring option: "
                metrics=("System Info" "CPU Usage" "Memory Usage" "Disk Space" "Back to Main Menu")
                select metric in "${metrics[@]}"; do
                    case $metric in
                        "System Info")
                            display_system_info
                            break
                            ;;
                        "CPU Usage")
                            display_cpu_usage
                            break
                            ;;
                        "Memory Usage")
                            display_memory_usage
                            break
                            ;;
                        "Disk Space")
                            display_disk_space
                            break
                            ;;
                        "Back to Main Menu")
                            break
                            ;;
                        *)
                            echo "Invalid option $REPLY";;
                    esac
                done
                ;;
            "File Management")
                PS3="Select a file management option: "
                file_ops=("Change Permissions" "Change Ownership" "Delete File/Directory" "Rename File/Directory" "Back to Main Menu")
                select op in "${file_ops[@]}"; do
                    case $op in
                        "Change Permissions")
                            change_permissions
                            break
                            ;;
                        "Change Ownership")
                            change_ownership
                            break
                            ;;
                        "Delete File/Directory")
                            delete_file
                            break
                            ;;
                        "Rename File/Directory")
                            rename_file
                            break
                            ;;
                        "Back to Main Menu")
                            break
                            ;;
                        *)
                            echo "Invalid option $REPLY";;
                    esac
                done
                ;;
            "Backup/Restore")
                PS3="Select a backup/restore option: "
                backup_ops=("Backup Files" "Restore Files" "Back to Main Menu")
                select op in "${backup_ops[@]}"; do
                    case $op in
                        "Backup Files")
                            backup_files
                            break
                            ;;
                        "Restore Files")
                            restore_files
                            break
                            ;;
                        "Back to Main Menu")
                            break
                            ;;
                        *)
                            echo "Invalid option $REPLY";;
                    esac
                done
                ;;
            "Generate Report")
                generate_report
                ;;
            "Exit")
                echo "Exiting..."
                break
                ;;
            *)
                echo "Invalid option $REPLY";;
        esac
    done
}

# Run the main menu
main_menu

