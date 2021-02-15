# Poppler Packaged for Windows

Download the latest Poppler prebuilt-binaries packaged with dependencies for Windows. Built with the help of conda-forge and [poppler-feedstock](https://github.com/conda-forge/poppler-feedstock). Includes the latest poppler-data.

## Download
![](https://github.com/oschwartz10612/poppler-windows/workflows/Package%20For%20Windows/badge.svg)

You can download the latest build from [releases](https://github.com/oschwartz10612/poppler-windows/releases/latest).

## Out of Date?

- Ensure that [poppler-feedstock](https://github.com/conda-forge/poppler-feedstock) is up to date. 

- Create a new pull request and bump `POPPLER_VERSION` in `package.sh` to the latest.  

- After merged the tag will be matched and the workflow will trigger a new release.

### Poppler-data out of date?

- Copy the latest download link for poppler-data from the [offical poppler site](https://poppler.freedesktop.org/).

- Create a new pull request and update the `POPPLER_DATA_URL` under in `package.sh`.  

- After merged the tag will be matched and the workflow will trigger a new release.
