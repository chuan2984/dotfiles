#!/bin/bash

# Customize the following:
# - escaped_path: absolute local path to your project
# - container: name of your docker container
escaped_path="\/Users\/chuanhe\/Github\/fieldwire_api\/" # Be careful to properly escape this
image_name=$(docker ps | grep fieldwire_api |  grep -v redis | awk '{print $2}' | awk -F'-' '{print $NF}')

# WARN: This will break if flags other than -o and -f are added in neotest-rspec
while getopts o:f: flag; do
	# This deliberately does not handle all arguments
	# shellcheck disable=SC2220
	# shellcheck disable=SC2213
	case "${flag}" in
		o) output_path=${OPTARG} ;;
	esac
done

# WARN: I dont think this is actually escaping
# Strip local path from test paths sent to container
args=("${@/$escaped_path/}")

# Run the tests
docker compose exec -it -e 'NO_COVERAGE=true' "$image_name" bundle exec spring rspec "${args[@]}"

# Copy the test output from the container to the host
docker compose cp "$image_name:ruby-app/$output_path" "$output_path" > /dev/null 2>&1

