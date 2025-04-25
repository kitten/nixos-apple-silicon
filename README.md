## About

> [!NOTE]
> #### `kitten/nixos-apple-silicon` Fork
> This is a fork of `tpwrules/nixos-apple-silicon`. The default branch is `edge`.
> Creating this fork, I've picked over commits from other forks and PRs, and after, have attempted to maintain a highly up-to-date
> version of Asahi packages for my own use (on a Macbook Air M2 15" J415).
>
> For M1 hardware, you may have to revert: https://github.com/kitten/nixos-apple-silicon/commit/81e6e14674bcc6581688dde42110764f95d235e0

This repository contains package expressions and NixOS configuration modules which are intended to provide a useful and straightforward bare metal NixOS experience on Apple Silicon Macs. Once NixOS is installed and the Apple Silicon configuration module is added, the system can be configured and operated like any other NixOS system.

We aim to generally replicate the experience and software configuration/versions provided by the Asahi Linux reference distro, and we rely primarily on their hard work. Contributions to improve the NixOS experience and address specific issues are welcome, but configuration and versions which diverge significantly will not be accepted.

Please see the documentation and guide below to get started.

## Documentation

* [Release Notes](docs/release-notes.md)
* [Setup, Installation, and Maintenance Guide (2025-02-03)](docs/uefi-standalone.md)

## Credits

This is mostly a restructuring of work many others have already done, and it wouldn't have been possible without them. Important parts of the NixOS on Apple Silicon experience include (but are not limited to):
* [Asahi Linux's m1n1 bootloader/hypervisor](https://github.com/AsahiLinux/m1n1)
* [Asahi Linux's kernel patches](https://github.com/AsahiLinux/linux)
* [Mark Kettenis' U-boot port](https://github.com/kettenis/u-boot)
* [Alyssa Rosenzweig's Mesa GPU driver](https://gitlab.freedesktop.org/asahi/mesa)

The Nix derivations and documentation in this repository are licensed under the MIT license as included in the [LICENSE](LICENSE) file. Patches included in this repository, and the files that Nix builds, are covered by separate licenses.
