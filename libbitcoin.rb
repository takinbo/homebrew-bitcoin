require 'formula'

class Libbitcoin < Formula
  homepage 'https://github.com/spesmilo/libbitcoin'
  url 'https://github.com/spesmilo/libbitcoin.git', :tag => 'v1.4'
  head 'https://github.com/spesmilo/libbitcoin.git', :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'homebrew/versions/gcc48' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  depends_on 'curl'  # todo: does this need gcc48?
  depends_on 'openssl'  # todo: does this need gcc48?
  depends_on 'WyseNynja/bitcoin/boost-gcc48' => 'c++11'
  depends_on 'WyseNynja/bitcoin/leveldb-gcc48'
  #depends_on 'WyseNynja/bitcoin/protobuf-gcc48' => 'c++11'  # mentioned in install docs, but seems unnecessary

  def patches
    # fixup Libs in libbitcoin.pc.in
    DATA
  end

  def install
    # we depend_on gcc48 (with -std=c++11), but PATH is in the wrong order so be explicit
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"
    ENV.cxx11

    # I thought depends_on boost-gcc48 would be enough, but I guess not...
    boostgcc48 = Formula.factory('WyseNynja/bitcoin/boost-gcc48')
    ENV.append 'CPPFLAGS', "-I#{boostgcc48.include}"
    ENV.append 'LDFLAGS', "-L#{boostgcc48.lib}"

    # I thought depends_on curl would be enough, but I guess not...
    curl = Formula.factory('curl')
    ENV.append 'CPPFLAGS', "-I#{curl.include}"
    ENV.append 'LDFLAGS', "-L#{curl.lib}"

    # I thought depends_on openssl would be enough, but I guess not...
    openssl = Formula.factory('openssl')
    ENV.append 'CPPFLAGS', "-I#{openssl.include}"
    ENV.append 'LDFLAGS', "-L#{openssl.lib}"

    # I thought depends_on leveldb-gcc48 would be enough, but I guess not...
    leveldbgcc48 = Formula.factory('WyseNynja/bitcoin/leveldb-gcc48')
    ENV.append 'CPPFLAGS', "-I#{leveldbgcc48.include}"
    ENV.append 'LDFLAGS', "-L#{leveldbgcc48.lib}"

    system "autoreconf", "-i"
    system "./configure", "--enable-leveldb",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libbitcoin`.
    system "false"
  end
end

__END__
diff --git a/libbitcoin.pc.in b/libbitcoin.pc.in
index 81880f3..aa6d18e 100644
--- a/libbitcoin.pc.in
+++ b/libbitcoin.pc.in
@@ -9,6 +9,6 @@ URL: http://libbitcoin.dyne.org
 Version: @PACKAGE_VERSION@
 Requires: libcurl
 Cflags: -I${includedir} -std=c++11 @CFLAG_LEVELDB@
-Libs: -L${libdir} -lbitcoin -lboost_thread -lboost_system -lboost_regex -lboost_filesystem -lpthread -lcurl @LDFLAG_LEVELDB@
+Libs: -L${libdir} -lbitcoin -lboost_filesystem -lboost_regex -lboost_system -lboost_thread-mt -lcurl @LDFLAG_LEVELDB@ -lpthread
 Libs.private: -lcrypto -ldl -lz
 
