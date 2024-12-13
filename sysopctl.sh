#!/bin/bash

VERSION="v0.1.0"

# Function to display help
function display_help() {
    echo "sysopctl $VERSION\n"
    echo "Usage:"
    echo "  sysopctl [OPTIONS] COMMAND [ARGUMENTS]\n"
    echo "Options:"
    echo "  --help      Display this help message"
    echo "  --version   Show the version of sysopctl\n"
    echo "Commands:"
    echo "  service list             List all active services"
    echo "  service start <name>     Start a specified service"
    echo "  service stop <name>      Stop a specified service"
    echo "  system load              Show current system load averages"
    echo "  disk usage               Show disk usage statistics\n"
    echo "Examples:"
    echo "  sysopctl service list"
    echo "  sysopctl service start apache2"
    echo "  sysopctl disk usage"
}


# Function to display version
function display_version() {
    echo "sysopctl $VERSION"
}

# Function to list running services
function list_services() {
    echo "SERVICE                STATUS"
    echo "-------------------------------"
    systemctl list-units --type=service --state=running | awk '{if (NR>1) print $1"                active"}'
}

# Function to display system load
function show_system_load() {
    uptime | awk -F 'load average: ' '{print "System Load Averages: "$2}'
}

# Function to start a service
function start_service() {
    if [ -z "$1" ]; then
        echo "Error: Service name is required."
        exit 1
    fi
    systemctl start "$1" && echo "Starting service $1: SUCCESS" || echo "Starting service $1: FAILED"
}

# Function to stop a service
function stop_service() {
    if [ -z "$1" ]; then
        echo "Error: Service name is required."
        exit 1
    fi
    systemctl stop "$1" && echo "Stopping service $1: SUCCESS" || echo "Stopping service $1: FAILED"
}

# Function to display disk usage
function check_disk_usage() {
    df -h | awk 'NR==1 || $1 ~ /^\/dev\// {print $0}'
}

# Main script logic
if [ "$1" == "--help" ]; then
    display_help
elif [ "$1" == "--version" ]; then
    display_version
elif [ "$1" == "service" ]; then
    if [ "$2" == "list" ]; then
        list_services
    elif [ "$2" == "start" ]; then
        start_service "$3"
    elif [ "$2" == "stop" ]; then
        stop_service "$3"
    else
        echo "Invalid service command. Use --help for usage information."
    fi
elif [ "$1" == "system" ]; then
    if [ "$2" == "load" ]; then
        show_system_load
    else
        echo "Invalid system command. Use --help for usage information."
    fi
elif [ "$1" == "disk" ]; then
    if [ "$2" == "usage" ]; then
        check_disk_usage
    else
        echo "Invalid disk command. Use --help for usage information."
    fi
else
    echo "Unknown command. Use --help for usage information."
fi

