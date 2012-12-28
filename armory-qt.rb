  head 'https://github.com/etotheipi/BitcoinArmory.git'
  url 'https://github.com/etotheipi/BitcoinArmory.git', :tag => 'v0.86.3-beta'
  version '0.86.3-beta'

  devel do
    url 'https://github.com/etotheipi/BitcoinArmory.git', :branch => 'testing'
    version 'testing'
  end
 
  option 'skip-verify', "Skip git-verify-tag"

  depends_on 'swig' => :build
  def patches
    DATA
  end

    if not build.devel? and not build.head? and not build.include? 'skip-verify'
      cd "#{cached_download}" do
        # prefix version with a "v" to match tags
        system "git verify-tag v#{version}"
      end
    end
    ENV.j1  # if your formula's build system can't parallelize
    system "mkdir -p #{share}/armory/"
    system "cp *.py *.so README LICENSE #{share}/armory/"
    ArmoryQt.command was installed in
      #{bin}
      ln -s #{bin}/ArmoryQt.command ~/Applications/ArmoryQt

    Or you can just run 'ArmoryQt.command' from your terminal

    You will need bitcoin-qt or bitcoind running if you want to go online.

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