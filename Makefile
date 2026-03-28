.PHONY: run build deploy

default: run

run:
	hugo server -D

build:
	hugo --minify

deploy: build
	firebase deploy --only hosting
