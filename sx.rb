require 'formula'

class Sx < Formula
  homepage 'https://github.com/spesmilo/sx'
  url 'https://github.com/spesmilo/sx.git', :tag => 'v0.2'
  head 'https://github.com/spesmilo/sx.git', :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'WyseNynja/bitcoin/libconfig-gcc48' => :build  # I thought depends_on obelisk would be enough, but I guess not...

  depends_on 'qrencode' => :recommended
  depends_on 'WyseNynja/bitcoin/libbitcoin'
  depends_on 'WyseNynja/bitcoin/obelisk'
  depends_on 'WyseNynja/bitcoin/zeromq2-gcc48'  # I thought depends_on obelisk would be enough, but I guess not...

  def install
    # we depend_on gcc48 (with -std=c++11), but PATH is in the wrong order so be explicit
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"
    ENV.cxx11

    # I thought depends_on obelisk/zermoq-gcc48 would be enough, but I guess not...
    libconfiggcc48 = Formula.factory('WyseNynja/bitcoin/libconfig-gcc48')
    ENV.append 'CPPFLAGS', "-I#{libconfiggcc48.include}"
    ENV.append 'LDFLAGS', "-L#{libconfiggcc48.lib}"

    # I thought depends_on obelisk/zermoq-gcc48 would be enough, but I guess not...
    zeromq2gcc48 = Formula.factory('WyseNynja/bitcoin/zeromq2-gcc48')
    ENV.append 'CPPFLAGS', "-I#{zeromq2gcc48.include}"
    ENV.append 'LDFLAGS', "-L#{zeromq2gcc48.lib}"

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
