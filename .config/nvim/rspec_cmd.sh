#!/bin/bash

# Customize the following:
# - escaped_path: absolute local path to your project
# - container: name of your docker container
escaped_path="\/Users\/chuanhe\/Github\/fieldwire_api\/" # Be careful to properly escape this
container_id=$(docker ps | rg api-web | awk {'print $1'})

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
docker exec -it -e 'NO_COVERAGE=true' "$container_id" bundle exec spring rspec "${args[@]}"

# Copy the test output from the container to the host
docker cp "$container_id:ruby-app/$output_path" "$output_path" > /dev/null 2>&1
