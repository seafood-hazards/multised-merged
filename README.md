# multised (merged)

Source for the **multised (merged)** website: the single **merged** marine-sediment
trace-element database (all five sources, Mareano, Vannmiljo, ICES-DOME, MUDAB and
4Demon, combined into one with cross-source duplicates removed) and the Norwegian
**aquaculture** reference database paired with it. The site documents their schemas
and offers interactive table and map viewers over them.

The site is a [Quarto](https://quarto.org) website. Unlike the sibling
[slim](https://github.com/seafood-hazards/multised-slim) and
[clean](https://github.com/seafood-hazards/multised-clean) sites (whose pages read
the databases with R at render time), the **Explore** pages here run **in the
browser**: the SQLite databases are loaded client-side via WebAssembly
([sql.js](https://sql.js.org) wrapped by
[stratum-sqlite](https://github.com/stratum-toolkit/stratum-sqlite)) and queried with
Observable JS. The build step only needs to download the databases so they can be
served as static files; the databases themselves are not stored in this repository.

Published site: <https://seafood-hazards.github.io/multised-merged/>

## Reproducing the site locally

### 1. Prerequisites

- [R](https://www.r-project.org/) 4.1 or newer
- [Quarto](https://quarto.org/docs/get-started/) 1.4 or newer
- The R packages the static DB Design (schema) pages need:

  ```r
  install.packages(c("rmarkdown", "knitr", "tibble"))
  ```

  The **Explore** pages need no R: they run entirely in the browser.

### 2. Download the databases

The pages read two SQLite databases, published on this repository's
[releases](https://github.com/seafood-hazards/multised-merged/releases):

```
multised_merged.sqlite   the merged database (all five sources, deduplicated)
aquaculture_no.sqlite     the Norwegian aquaculture reference
```

You do not have to download these by hand: the site's `pre-render` step
(`download_resources.R`) fetches any that are missing into the repository root
whenever you `quarto render`, along with the client-side libraries
(`libs/sqljs/`) if they are absent. The commands below fetch the databases without
rendering:

```bash
# Merged + aquaculture databases, from this repository's v0.1.0 release
for f in multised_merged.sqlite aquaculture_no.sqlite; do
  curl -LO https://github.com/seafood-hazards/multised-merged/releases/download/v0.1.0/$f
done
```

They land in the repository root and are git-ignored. To build against the live
pipeline output instead, copy (or symlink) the two files from the `sedimenter`
project's `data/db/` directory.

### 3. Render the site

```bash
quarto render     # builds the whole site into _site/
# or, for a live-reloading preview while editing:
quarto preview
```

The output lands in `_site/` (git-ignored). The databases and `libs/sqljs/` are
copied into `_site/` (declared under `project: resources:` in `_quarto.yml`) so the
browser can load them.

### 4. Publishing

The site is published automatically by GitHub Actions
(`.github/workflows/publish.yml`) on every push to `main`: the workflow installs R
and Quarto, renders the site (the `pre-render` step downloads the databases), and
deploys to GitHub Pages. Enable it once under
**Settings > Pages > Source = GitHub Actions**; after that no local render or manual
upload is needed.

To point the site at a different database release, change the release tag in
`download_resources.R`.

## How the databases are built

The merge pipeline (union, deduplication, finalise) and the aquaculture table live
in the [`sedimenter`](https://github.com/seafood-hazards/sedimenter) project
(`R/merge/`, `R/aquaculture/`); the merge steps are also documented on the
[clean-analyses site](https://seafood-hazards.github.io/multised-clean/).

## Repository layout

```
*.qmd                   the site pages
_db-setup*.qmd          open the merged / aquaculture DB in the browser (included by Explore pages)
_quarto.yml             site configuration; pre-render hook, header include, resources
download_resources.R    pre-render: download the databases and client-side libraries
header.html             sets the in-browser database paths; loads stratum-sqlite
libs/sqljs/             sql.js engine + stratum-sqlite wrapper (served to the browser)
styles.css              small style overrides
*.sqlite                the SQLite databases (git-ignored; auto-downloaded)
_site/                  rendered output (git-ignored)
```
