image_name ?= hugo-dev
hugo_port ?= 1313

# BUILD COMMANDS
build_docker_shell:
	docker build -t ${image_name}-shell -f ./docker/dockerfile_shell . --no-cache

build_docker_serve:
	docker build -t ${image_name}-serve -f ./docker/dockerfile_hugo . --no-cache

shell: clean build_docker_shell
	docker run --name ${image_name}-shell \
	--mount type=bind,source=./src,target=/src \
	--mount type=bind,source=./build,target=/build \
	-it ${image_name}-shell
	

serve: clean build_docker_serve
	docker run --name ${image_name}-serve \
	--mount type=bind,source=./src,target=/src \
	--mount type=bind,source=./build,target=/build \
	-it -p ${hugo_port}:${hugo_port} ${image_name}-serve

clean:
	docker rm --force ${image_name}-shell
	docker rm --force ${image_name}-serve