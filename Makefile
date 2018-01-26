.PHONY: run

ROOT := $(shell pwd)

default: run

run:
	docker run -t --rm -v "$(ROOT)":/usr/src/app:delegated -e JEKYLL_GITHUB_TOKEN=$(GITHUB_API_TOKEN) -p "4000:4000" starefossen/github-pages
