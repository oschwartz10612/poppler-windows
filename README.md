# Poppler Packaged for Windows

Download the latest Poppler prebuilt-binaries packaged with dependencies for Windows. Built with the help of conda-forge and [poppler-feedstock](https://github.com/conda-forge/poppler-feedstock). Includes the latest poppler-data.

## Download
![](https://github.com/oschwartz10612/poppler-windows/workflows/Package%20For%20Windows/badge.svg)

You can download the latest build from [releases](https://github.com/oschwartz10612/poppler-windows/releases/latest).

## What is this?
Please note that the purpose of this repository is solely to download the compiled Poppler binaries from conda-forge poppler-feedstock and put everything in a nice zip for use. This repository does not build Poppler. If you believe you have an issue with poppler itself - or the building of it - please direct those requests to the upstream sources with Poppler team or the guys over at [poppler-feedstock](https://github.com/conda-forge/poppler-feedstock).

## Out of Date?

- Ensure that [poppler-feedstock](https://github.com/conda-forge/poppler-feedstock) is up to date. 

- Create a new pull request and bump `POPPLER_VERSION` in `package.sh` to the latest.  

- Sometimes the feedstock does an update on the same version in order to apply a fix and we need to do a repackage here. If the version has been packaged already, increase the build number by 1 in `package.sh`. If it has not been packaged yet, reset the build number to 0.

- After merged the tag will be matched and the workflow will trigger a new release.

### Poppler-data out of date?

- Copy the latest download link for poppler-data from the [offical Poppler site](https://poppler.freedesktop.org/).

- Create a new pull request and update the `POPPLER_DATA_URL` under in `package.sh`. 

- Sometimes the feedstock does an update on the same version in order to apply a fix and we need to do a repackage here. If the version has been packaged already, increase the build number by 1 in `package.sh`. If it has not been packaged yet, reset the build number to 0.

- After merged the tag will be matched and the workflow will trigger a new release.
