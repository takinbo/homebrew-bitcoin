This repository contains WyseNynja's UNOFFICIAL brews relating to bitcoin.

These brews can be installed via the raw GitHub URLs, or by cloning this repository locally with `brew tap WyseNynja/bitcoin && brew prune`.

Remember to run `brew update`, `brew prune`, and `brew doctor` often!

If you want something added to this repo, let me know with the issue tracker.  It should be easy enough to add things as long as they have build instructions for mac.  There are other taps with mining tools, but I could add those here if there is interest.

If you know anything that could help make these formula better or if anything doesn't work for you, please contribute to the issue tracker here!

If you find this tap useful, my Bitcoin address is 1NcJr3YyL6qKDPVVhG8ViNADcUhVvn3v9n.


# Formula

## Armory-QT

Armory is having issues on OS X.  It seems to hang and crash after a few minutes of use.  Mavericks seems even less stable.

## bitcoind

This formula has been updated to install bitcoind and bitcoin-cli version 0.10.0

**IMPORTANT**: If you are upgrading, be sure to also upgrade openssl with `brew update; brew upgrade openssl`!

## bitcoind-next-test

This is @luke-jr's branch of things upcoming in the main bitcoind.  It currently does not work on Mavericks.  Stay tuned!

## bitcoind-sipa-watchonly

This is @sipa's branch with watch-only addresses.  This can be used for [coinpunk](https://github.com/kyledrake/coinpunk/blob/master/docs/INSTALL-OSX.md).

## libbitcoin / Obelisk / sx

These formula require GCC 4.8 which is newer than the compiler that comes with OS X (and comes from `brew tap homebrew/versions`).  Because of this, building these packages takes a while, but they seem to be working! Hard coding other versions of compilers into a formula like this is not supported by the brew developers, but I don't see any other way.

This formula are currently broken because they have rearranged their repos.

## Vanitygen

I am pretty sure this works, but I don't have a system to test the GPU or pooled mining.

