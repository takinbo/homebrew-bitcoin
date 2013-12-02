require 'formula'

class Obelisk < Formula
  homepage 'https://github.com/spesmilo/obelisk'
  url 'https://github.com/spesmilo/obelisk.git', :tag => 'v0.2'
  head 'https://github.com/spesmilo/obelisk.git', :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'homebrew/versions/gcc48' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'WyseNynja/bitcoin/libconfig-gcc48' => :build  # todo: does this need gcc48?

  depends_on 'WyseNynja/bitcoin/boost-gcc48'
  depends_on 'WyseNynja/bitcoin/leveldb-gcc48'
  depends_on 'WyseNynja/bitcoin/libbitcoin'
  depends_on 'WyseNynja/bitcoin/zeromq2-gcc48'

  def install
    # we depend on gcc48 for build, but the PATH is in the wrong order
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"

    # I thought depends_on libconfig-gcc48 would be enough, but I guess not...
    libconfiggcc48 = Formula.factory('WyseNynja/bitcoin/libconfig-gcc48')
    ENV.append 'CPPFLAGS', "-I#{libconfiggcc48.include}"
    ENV.append 'LDFLAGS', "-L#{libconfiggcc48.lib}"

    # I thought depends_on boost-gcc48 would be enough, but I guess not...
    boostgcc48 = Formula.factory('WyseNynja/bitcoin/boost-gcc48')
    ENV.append 'CPPFLAGS', "-I#{boostgcc48.include}"
    ENV.append 'LDFLAGS', "-L#{boostgcc48.lib}"

    # I thought depends_on leveldb-gcc48 would be enough, but I guess not...
    leveldbgcc48 = Formula.factory('WyseNynja/bitcoin/leveldb-gcc48')
    ENV.append 'CPPFLAGS', "-I#{leveldbgcc48.include}"
    ENV.append 'LDFLAGS', "-L#{leveldbgcc48.lib}"

    # I thought depends_on zermoq-gcc48 would be enough, but I guess not...
    zeromq2gcc48 = Formula.factory('WyseNynja/bitcoin/zeromq2-gcc48')
    ENV.append 'CPPFLAGS', "-I#{zeromq2gcc48.include}"
    ENV.append 'LDFLAGS', "-L#{zeromq2gcc48.lib}"

    # this is set in libbitcoin.pc.in
    ENV.cxx11

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    #system "make"
    system "make", "install"
  end

  test do
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test obelisk`.
    system "false"
  end
end
