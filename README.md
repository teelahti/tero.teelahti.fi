# tero.teelahti.fi

tero.teelahti.fi blog hosted on Google Firebase hosting. Originally forked from mmistakes/jekyll-theme-basically-basic. Credits to [Manymistakes](http://mademistakes.com) for the original design & Jekyll integration.

Could easily be hosted on Github pages by changing theme and gem lines on Gemfile and _config.yml; check comments
on those files.

## Local development

See Makefile.

## Deploy to firebase

Deployment is done with Google Cloud Container builder on each push, see cloudbuild.yaml for details. To set this up create
a CI token with `firebase login:ci`, and set up a Cloud Container Builder job with that token.


To build and deploy locally for test purposes do

    make deploy
