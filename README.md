# tero.teelahti.fi

Personal blog hosted on Google Firebase Hosting. Built with [Hugo](https://gohugo.io/)
using the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme.

## Local development

Requires [Nix](https://nixos.org/) with flakes enabled. If you use
[direnv](https://direnv.net/), run `direnv allow` and Hugo will be available
automatically.

```sh
# Enter dev shell (if not using direnv)
nix develop

# Start local dev server at http://localhost:1313
make run

# Build the site
make build
```

## Deploy

Deployment is done automatically with GitHub Actions on each push to `master`.
See `.github/workflows/build-and-deploy.yml` for details.

To build and deploy locally:

    make deploy
