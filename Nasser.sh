#!/bin/bash

create_file() {
    read -p "Enter the file path to create: " file_path
    touch "$file_path"
    echo "File created at: $file_path"
}

create_directory() {
    read -p "Enter the directory path to create: " dir_path
    mkdir -p "$dir_path"
    echo "Directory created at: $dir_path"
}

copy_file() {
    read -p "Enter the source file path: " src
    read -p "Enter the destination file path: " dest
    cp "$src" "$dest"
    echo "File copied from $src to $dest"
}

move_file() {
    read -p "Enter the source file path: " src
    read -p "Enter the destination file path: " dest
    mv "$src" "$dest"
    echo "File moved from $src to $dest"
}

rename_file() {
    read -p "Enter the current file path: " src
    read -p "Enter the new file name: " new_name
    mv "$src" "$(dirname "$src")/$new_name"
    echo "File renamed from $src to $(dirname "$src")/$new_name"
}

delete_file() {
    read -p "Enter the file path to delete: " file_path
    rm "$file_path"
    echo "File deleted: $file_path"
}

delete_directory() {
    read -p "Enter the directory path to delete: " dir_path
    rm -r "$dir_path"
    echo "Directory deleted: $dir_path"
}

show_menu() {
    echo
    echo "File and Directory Operations:"
    echo "1. Create File"
    echo "2. Create Directory"
    echo "3. Copy File"
    echo "4. Move File"
    echo "5. Rename File"
    echo "6. Delete File"
    echo "7. Delete Directory"
    echo "8. Exit"
}

while true; do
    show_menu
    read -p "Enter your choice (1-8): " choice

    case $choice in
        1) create_file ;;
        2) create_directory ;;
        3) copy_file ;;
        4) move_file ;;
        5) rename_file ;;
        6) delete_file ;;
        7) delete_directory ;;
        8) echo "Exiting the program."; break ;;
        *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
    esac
done
