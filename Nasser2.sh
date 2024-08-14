#!/bin/bash

search_by_name() {
    read -p "Enter the file name pattern to search for: " name_pattern
    find . -type f -name "*$name_pattern*" -print
}

search_by_type() {
    read -p "Enter the file type to search for (e.g., txt, jpg): " file_type
    find . -type f -name "*.$file_type" -print
}

search_by_size() {
    read -p "Enter the minimum file size in bytes (e.g., 1024): " min_size
    read -p "Enter the maximum file size in bytes (e.g., 1048576): " max_size
    find . -type f -size +"$min_size"c -size -"$max_size"c -print
}

search_by_mod_date() {
    read -p "Enter the modification date (YYYY-MM-DD) to search for files modified after this date: " mod_date
    find . -type f -newermt "$mod_date" -print
}

show_menu() {
    echo
    echo "File Search Operations:"
    echo "1. Search by File Name"
    echo "2. Search by File Type"
    echo "3. Search by File Size"
    echo "4. Search by Modification Date"
    echo "5. Exit"
}

while true; do
    show_menu
    read -p "Enter your choice (1-5): " choice

    case $choice in
        1) search_by_name ;;
        2) search_by_type ;;
        3) search_by_size ;;
        4) search_by_mod_date ;;
        5) echo "Exiting the program."; break ;;
        *) echo "Invalid choice. Please enter a number between 1 and 5." ;;
    esac
done


