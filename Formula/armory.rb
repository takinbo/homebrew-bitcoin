class Armory < Formula
  desc "Bitcoin wallet with cold storage and multisig support"
  homepage "https://bitcoinarmory.com/"
  url 'https://github.com/etotheipi/BitcoinArmory.git', :tag => 'v0.93.2'
  version '0.93.2'

  devel do
    url "https://github.com/etotheipi/BitcoinArmory.git", :branch => "gitian-ffreeze"
    version "dev"
  end

  option "codesign-app", "Codesign ArmoryQt.app (untested)"
  option "with-app", "Build ArmoryQt.app (untested)"

  depends_on "cryptopp"
  depends_on "gettext"
  # brew uses it's own PATH during installs, so a custom installed gpg (like from GPGTools) won't be found
  depends_on "gpg" => :recommended
  depends_on "libpng"
  depends_on :python
  depends_on :python => "twisted" if build.without? "app"
  depends_on :python => "psutil" if build.without? "app"
  depends_on "pyqt"
  depends_on "sip"
  depends_on "swig"
  depends_on :xcode if build.include? "codesign-app"
  depends_on "xz"

  def patches
    DATA
  end

  def install
    if not build.devel? and not build.head? and not build.without? "gpg"
      cd "#{cached_download}" do
        # prefix version with a "v" to match tags
        system "git verify-tag v#{version}"
      end
    end

    ENV.deparallelize

    if build.with? "app"
      system "make osx"
      cd "osxbuild" do
        prefix.install "Armory.app"
      end
    else
      system "make"
      system "mkdir -p #{share}/armory/img"
      system "mkdir -p #{share}/armory/extras"
      system "mkdir -p #{share}/armory/bitcoinrpc_jsonrpc"
      system "mkdir -p #{share}/armory/txjsonrpc"
      system "mkdir -p #{share}/armory/txjsonrpc/web"
      system "mkdir -p #{share}/armory/ui"
      system "mkdir -p #{share}/armory/pytest"
      system "mkdir -p #{share}/armory/BitTornado/BT1"
      system "mkdir -p #{share}/armory/urllib3"
      system "cp *.py *.so README.md LICENSE #{share}/armory/"
      system "rsync -rupE armoryengine #{share}/armory/"
      system "rsync -rupE --exclude='img/.DS_Store' img #{share}/armory"
      system "cp extras/*.py #{share}/armory/extras"
      system "cp bitcoinrpc_jsonrpc/*.py #{share}/armory/bitcoinrpc_jsonrpc"
      system "cp -r txjsonrpc/*.py #{share}/armory/txjsonrpc"
      system "cp -r txjsonrpc/web/*.py #{share}/armory/txjsonrpc/web"
      system "cp ui/*.py #{share}/armory/ui"
      system "cp pytest/*.py #{share}/armory/pytest"
      system "cp -r urllib3/*.py #{share}/armory/urllib3"
      system "cp BitTornado/*.py #{share}/armory/BitTornado"
      system "cp BitTornado/BT1/*.py #{share}/armory/BitTornado/BT1"
      system "cp default_bootstrap.torrent #{prefix}/armory"
      bin.install 'ArmoryQt.command'
    end
  end

  def caveats
    if build.with? "app"
      <<-EOS
      ArmoryQt.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps

      You will need Bitcoin-Core or bitcoind running if you want to go online.
      EOS
    else
      <<-EOS.undent
      ArmoryQt.command was installed in
        #{bin}

      To symlink into ~/Applications, you can do:
        ln -s #{bin}/ArmoryQt.command ~/Applications/ArmoryQt

      Or you can just run 'ArmoryQt.command' from your terminal

      You will need Bitcoin-Core or bitcoind running if you want to go online.
      EOS
    end
  end
end

__END__
diff --git a/ArmoryQt.command b/ArmoryQt.command
new file mode 100644
index 0000000..2cc2154
--- /dev/null
+++ b/ArmoryQt.command
@@ -0,0 +1,3 @@
+#!/bin/sh
+PYTHONPATH=`brew --prefix`/lib/python2.7/site-packages /usr/bin/python `brew --prefix`/share/armory/ArmoryQt.py $@
+
diff --git a/osxbuild/deploy.sh b/osxbuild/deploy.sh
index de3e31b..11b6975 100755
--- a/osxbuild/deploy.sh
+++ b/osxbuild/deploy.sh
@@ -14,15 +14,12 @@ function get_dependencies()
 {
     # get build dependencies
     echo "Installing dependencies..."
-    brew install cryptopp swig qt pyqt wget
-    sudo pip install virtualenv 
-    sudo pip install psutil
 }
 
 function make_env()
 {
     echo "Making python environment..."
-    virtualenv -q env
+    virtualenv -p /usr/bin/python -q env
     cd env
     bin/pip install twisted >/dev/null
     bin/pip install psutil 
diff --git a/cppForSwig/Makefile b/cppForSwig/Makefile
index ba6cc45..45b2e7e 100755
--- a/cppForSwig/Makefile
+++ b/cppForSwig/Makefile
@@ -17,9 +17,12 @@ OBJS = UniversalTimer.o BinaryData.o leveldb_wrapper.o StoredBlockObj.o BtcUtils
 # pypaths.txt to define those three variables, and then comment out
 # DO_EXEC_WHEREISPY line (to prevent the script from attempting to run
 # and overwriting the manual values).
-DO_EXEC_WHEREISPY := $(shell ./whereispy.sh)
+# DO_EXEC_WHEREISPY := $(shell ./whereispy.sh)

-include ./pypaths.txt
+# include ./pypaths.txt
+PYTHON_INCLUDE=`python-config --prefix`/include/python2.7/
+PYVER=python2.7
+PYTHON_LIB=`python-config --prefix`/lib/python2.7/config/libpython2.7.a

 INCLUDE_OPTS += -Icryptopp -Ileveldb/include -DUSE_CRYPTOPP -D__STDC_LIMIT_MACROS
 LIBRARY_OPTS += -lpthread -Lleveldb -L$(PYTHON_LIB) -l$(PYVER)
