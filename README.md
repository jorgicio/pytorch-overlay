<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [PyTorch Gentoo Overlay](#pytorch-gentoo-overlay)
  - [Installation](#installation)
    - [Using eselect/repository (Recommended)](#using-eselectrepository-recommended)
    - [Using Layman](#using-layman)
    - [Manually](#manually)
  - [Collaboration](#collaboration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# PyTorch Gentoo Overlay

This Overlay is in testing phase in order to provide the [PyTorch](https://pytorch.org) framework and Torchvision.
The ebuilds presented here are based in the work done by [Alexei Chernov](https://github.com/aclex) in [his repo](https://github.com/aclex/pytorch-ebuild).

## Installation

Since this repo is unregistered, it may be installed manually using its URL.

### Using eselect/repository (Recommended)

Be sure of having installed the `eselect-repository` package.

Then, add this repo:

    eselect repository add pytorch git https://github.com/jorgicio/pytorch-overlay.git

Then, you may syncronize it using commands like `emerge --sync` or `emaint sync -r pytorch`.

### Using Layman

If you use Layman with the `USE=git` enabled (it should be by default), you can use the provided `repo.xml` file to do so.

    layman -o https://github.com/jorgicio/pytorch-overlay/raw/master/repo.xml -f -a pytorch

Then synchronize it with `layman -s pytorch`, or `layman -S` for all repos.

### Manually

Add the following lines to a file inside the `/etc/portage/repos.conf` directory (you can name it as you wish):


    [pytorch]
    location = /var/db/repos/pytorch
    sync-type = git
    sync-uri = https://github.com/jorgicio/pytorch-overlay.git


Then, go to the parent directory mentioned in the file above. In this case, go to `/var/db/repos` and do this command with `git`:

    git clone https://github.com/jorgicio/pytorch-overlay.git pytorch

The `pytorch` directory will be created. Remember that everything mentioned in this section it's only done once. The repo will be synched with the other ones you have them added.

## Collaboration

This repo needs collaborators. Feel free to submit issues and/or pull requests.

Thanks in advance.
