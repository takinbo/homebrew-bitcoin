This repository contains WyseNynja's UNOFFICIAL brews relating to bitcoin.

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally with `brew tap WyseNynja/bitcoin`.

After tapping, run `brew prune` so that you don't have to prefix formula with 'WyseNynja/bitcoin/'

And run `brew update` and `brew doctor` often!

If you find this tap useful, my Bitcoin address is 1NcJr3YyL6qKDPVVhG8ViNADcUhVvn3v9n.

# Formula

## Armory-QT

Armory is having issues on OS X.  It seems to hang and crash after a few minutes of use.  Mavericks seems even less stable.

## bitcoind

This formula currently has trouble on Mavericks.  You will have to install with `--HEAD` until the next bitcoind release (>0.8.5).

## bitcoind-next-test

This is @luke-jr's branch of things upcoming in the main bitcoind.  It currently does not work on Mavericks.  Stay tuned!

## libbitcoin / Obelisk / sx

These formula require GCC 4.8 which is newer than the compiler that comes with OS X.  Because of this, building these packages takes a while and the formula are a bit more complex.  Hard coding other versions of compilers into a formula like this is not supported by the brew developers, but I don't see any other way.  I'm also not very happy with the CPPFLAGS and LDFLAGS stuff, but it seems to be working.

I have successfully compiled libbitcoin, obelisk, and sx on Mavericks.  I've yet to actually do much testing of them yet, so things might still be broken.

If you have anything that could help make these formula better, please contribute anything you know to the open issues or open a new issue!

## Vanitygen

I am pretty sure this works, but I don't have a system to test the GPU or pooled mining.
