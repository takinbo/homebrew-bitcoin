require 'formula'

class Sx < Formula
  homepage 'https://github.com/spesmilo/sx'
  url 'https://github.com/spesmilo/sx.git', :tag => 'v0.2'
  head 'https://github.com/spesmilo/sx.git', :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build

  depends_on 'qrencode' => :recommended
  depends_on 'WyseNynja/bitcoin/boost-gcc48' => 'c++11'
  depends_on 'WyseNynja/bitcoin/libbitcoin'
  depends_on 'WyseNynja/bitcoin/libconfig-gcc48'
  depends_on 'WyseNynja/bitcoin/zeromq2-gcc48'
  depends_on 'WyseNynja/bitcoin/obelisk'

  def install
    ENV.prepend_path 'PATH', "#{HOMEBREW_PREFIX}/opt/gcc48/bin"
    ENV['CC'] = "gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "g++-4.8"
    ENV.cxx11

    # I thought depends_on boost-gcc48 would be enough, but I guess not...
    boostgcc48 = Formula.factory('WyseNynja/bitcoin/boost-gcc48')
    ENV.append 'CPPFLAGS', "-I#{boostgcc48.include}"
    ENV.append 'LDFLAGS', "-L#{boostgcc48.lib}"

    # I thought depends_on libconfig-gcc48 would be enough, but I guess not...
    libconfiggcc48 = Formula.factory('WyseNynja/bitcoin/libconfig-gcc48')
    ENV.append 'CPPFLAGS', "-I#{libconfiggcc48.include}"
    ENV.append 'LDFLAGS', "-L#{libconfiggcc48.lib}"

    # I thought depends_on zermoq-gcc48 would be enough, but I guess not...
    zeromq2gcc48 = Formula.factory('WyseNynja/bitcoin/zeromq2-gcc48')
    ENV.append 'CPPFLAGS', "-I#{zeromq2gcc48.include}"
    ENV.append 'LDFLAGS', "-L#{zeromq2gcc48.lib}"

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
