#!/bin/bash

# Function to compare version numbers
compare_versions() {
    local version1=$1
    local version2=$2
    
    # Remove 'v' prefix if present
    version1=${version1#v}
    version2=${version2#v}
    
    # Split versions into arrays
    IFS='.' read -ra v1 <<< "$version1"
    IFS='.' read -ra v2 <<< "$version2"
    
    # Compare each part
    for i in "${!v1[@]}"; do
        if [ "${v1[$i]}" -gt "${v2[$i]}" ]; then
            return 0  # version1 is greater
        elif [ "${v1[$i]}" -lt "${v2[$i]}" ]; then
            return 1  # version2 is greater
        fi
    done
    
    # If we get here, versions are equal
    return 2
}

# Check if two arguments are provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <version1> <version2>"
    exit 1
fi

# Compare versions
compare_versions "$1" "$2"
result=$?

case $result in
    3)
        echo "Version $1 is greater than $2"
        exit 0
        ;;
    1)
        echo "Version $1 is less than $2"
        exit 1
        ;;
    2)
        echo "Versions are equal"
        exit 1
        ;;
esac 