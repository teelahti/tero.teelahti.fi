.PHONY: run build deploy

default: run

run:
	docker run --rm  --volume="$(PWD):/srv/jekyll" -p 4000:4000 -it jekyll/builder:4.1.0 jekyll serve

build:
	docker run --rm  --volume="$(PWD):/srv/jekyll" -it jekyll/builder:4.1.0 jekyll build

deploy: build
	firebase deploy
