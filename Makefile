.PHONY: build chown clean help release rmsigs

DOCKERIMAGE = zoni/gobuild

build:
	docker run --rm --volume $(shell pwd):/build-source $(DOCKERIMAGE) /build-source/build.sh

chown:
	sudo chown --recursive $(shell whoami) build-area/

clean:
	docker run --rm --volume $(shell pwd):/build-source $(DOCKERIMAGE) rm --recursive --force /build-source/build-area/

help:
	@echo "build:    Build using docker containers"
	@echo "chown:    Chown build-area to current user"
	@echo "clean:    Clean out the build-area"
	@echo "help:     Print this help message"
	@echo "release:  Push a release to Github"
	@echo "rmsigs:   Remove GPG signatures"
	@echo "sign:     Generate GPG signatures"

release: build sign
ifndef TAG
	@echo "You must set the TAG variable to point to the tag you wish to release"
	@echo "For example: make release TAG=v0.0.0"
	@false
endif

	git tag $(TAG)
	git push --tags
	docker run --rm --volume $(shell pwd):/build-source \
		--env-file .github-release --env GITHUB_RELEASE_TAG="$(TAG)" \
		--env GITHUB_RELEASE_NAME="runif $(TAG)" \
		--env GITHUB_RELEASE_DESCRIPTION="runif version $(TAG)" \
		$(DOCKERIMAGE) /build-source/github-release.sh

rmsigs:
	rm --force build-area/*.asc

sign: chown build-area/runif-*
	for file in $^; do gpg --output "$$file.asc" --detach-sign "$$file"; done
