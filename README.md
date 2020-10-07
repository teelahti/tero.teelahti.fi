# tero.teelahti.fi

tero.teelahti.fi blog hosted on Google Firebase hosting. Originally forked from
mmistakes/jekyll-theme-basically-basic. Credits to [Manymistakes](http://mademistakes.com)
for the original design & Jekyll integration.

Could easily be hosted on Github pages by changing theme and gem lines on Gemfile and \_config.yml;
check comments on those files.

## Local development

See Makefile.

## Deploy to firebase

Deployment is done with Github actions on each push, see .github folder for details. To set this
up create a CI token with `firebase login:ci`, save the output to Github secret FIREBASE_TOKEN.

To build and deploy locally for test purposes do

    make deploy
