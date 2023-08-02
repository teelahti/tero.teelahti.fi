.PHONY: run build deploy

default: run

# To set ruby to be brew-installed ruby do: 
# brew link --overwrite --force ruby
# To link the default version back do
# brew unlink ruby

run:
	# For amd version use jekyll/builder instead of this arm image
	# docker run --rm  --volume="$(PWD):/srv/jekyll" -p 4000:4000 -it rockstorm/jekyll:4 jekyll serve
	# Local Jekyll installation version
	jekyll serve
	
build:
	# docker run --rm  --volume="$(PWD):/srv/jekyll" -it jekyll/builder:4.1.0 jekyll build
	jekyll build
	
deploy: build
	firebase deploy
