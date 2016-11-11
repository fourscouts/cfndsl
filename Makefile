DOCKER_IMAGE = fourstacks/cfndsl
HADOLINT_DOCKER = fourstacks/hadolint:release-0.1
SERVERSPEC_DOCKER = fourstacks/serverspec:release-0.3.7

.PHONY: test build

build:
	docker build -t $(DOCKER_IMAGE) $(CURDIR)

lint:
	@echo "start linting the Dockerfile"
	@docker run --rm -i $(HADOLINT_DOCKER) hadolint --ignore DL3008 --ignore DL3013 - < Dockerfile
	@echo "finished linting the Dockerfile"

test: build lint
	@echo "running serverspec tests on the Dockerfile"
	@docker run -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(PWD):/projectfiles" --workdir /projectfiles/tests --entrypoint "rake" $(SERVERSPEC_DOCKER) project_dir='' serverspec:cfndsl

shell:
	@docker run -it -v "/var/run/docker.sock:/var/run/docker.sock" -v "$(PWD):/projectfiles" $(DOCKER_IMAGE) bash
