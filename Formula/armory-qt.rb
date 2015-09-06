require 'formula'

class ArmoryQt < Formula
  homepage 'https://bitcoinarmory.com/'
  url 'https://github.com/etotheipi/BitcoinArmory.git', :tag => 'v0.93'
  version '0.93'

  devel do
    url 'https://github.com/etotheipi/BitcoinArmory.git', :branch => 'dev'
    version 'dev'
  end

  option 'codesign-app', 'Codesign ArmoryQt.app (untested)'
  option 'with-app', 'Build ArmoryQt.app (untested)'

  depends_on 'cryptopp'
  depends_on 'libpng'
  depends_on :python => 'psutil' if build.without? 'app'
  depends_on 'pyqt'
  depends_on :python
  depends_on 'sip'
  depends_on 'swig'
  depends_on :python => 'twisted' if build.without? 'app'
  depends_on :xcode if build.include? 'codesign-app'

  # brew uses it's own PATH during installs, so a custom installed gpg (like from GPGTools) won't be found
  depends_on 'gpg' => :recommended

  def patches
    DATA
  end

  def install
    if not build.devel? and not build.head? and not build.without? 'gpg'
      cd "#{cached_download}" do
        # prefix version with a "v" to match tags
        system "git verify-tag v#{version}"
      end
    end

    ENV.j1  # if your formula's build system can't parallelize

    if build.with? 'app'
      system "make osx"
      cd "osxbuild" do
        prefix.install "Armory.app"
      end
    else
      system "make"
      # todo: these directories change with v0.90
      system "mkdir -p #{share}/armory/img"
      system "mkdir -p #{share}/armory/extras"
      system "mkdir -p #{share}/armory/jsonrpc"
      system "mkdir -p #{share}/armory/dialogs"
      system "cp *.py *.so README LICENSE #{share}/armory/"
      system "cp img/* #{share}/armory/img"
      system "cp extras/*.py #{share}/armory/extras"
      system "cp jsonrpc/*.py #{share}/armory/jsonrpc"
      system "cp dialogs/*.py #{share}/armory/dialogs"
      bin.install 'ArmoryQt.command'
    end
  end

  def caveats
    if build.with? 'app'
      <<-EOS
      ArmoryQt.app was installed in:
        #{prefix}

      To symlink into ~/Applications, you can do:
        brew linkapps

      You will need bitcoin-qt or bitcoind running if you want to go online.
      EOS
    else
      <<-EOS.undent
      ArmoryQt.command was installed in
        #{bin}

      To symlink into ~/Applications, you can do:
        ln -s #{bin}/ArmoryQt.command ~/Applications/ArmoryQt

      Or you can just run 'ArmoryQt.command' from your terminal

      You will need bitcoin-qt or bitcoind running if you want to go online.
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
