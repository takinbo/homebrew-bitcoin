This repository contains WyseNynja's UNOFFICIAL brews relating to bitcoin.

These brews can be installed via the raw GitHub URLs, or by cloning this repository locally with `brew tap WyseNynja/bitcoin && brew prune`.

Remember to run `brew update`, `brew prune`, and `brew doctor` often!

If you have anything that could help make these formula better or if anything doesn't work for you, please contribute to the issue tracker here!

If you find this tap useful, my Bitcoin address is 1NcJr3YyL6qKDPVVhG8ViNADcUhVvn3v9n.

# Formula

## Armory-QT

Armory is having issues on OS X.  It seems to hang and crash after a few minutes of use.  Mavericks seems even less stable.

## bitcoind

This formula currently has trouble on Mavericks.  You will have to install with `--HEAD` until the next bitcoind release (>0.8.6).

## bitcoind-next-test

This is @luke-jr's branch of things upcoming in the main bitcoind.  It currently does not work on Mavericks.  Stay tuned!

## libbitcoin / Obelisk / sx

These formula require GCC 4.8 which is newer than the compiler that comes with OS X (and comes from `brew tap homebrew/versions`).  Because of this, building these packages takes a while, but they seem to be working! Hard coding other versions of compilers into a formula like this is not supported by the brew developers, but I don't see any other way.

I haven't done much testing yet, so things might still be broken, but the quick things I have played with seemed to work.  Please open an issue if you see anything wrong!  And don't use these packages for merchant purposes until they are fully tested.

## Vanitygen

I am pretty sure this works, but I don't have a system to test the GPU or pooled mining.
