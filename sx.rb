require 'formula'

class Sx < Formula
  homepage 'https://github.com/spesmilo/sx'
  url 'https://github.com/spesmilo/sx.git', :tag => 'v0.2'
  head 'https://github.com/spesmilo/sx.git', :branch => 'master'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build

  depends_on 'qrencode' => :recommended
  depends_on 'WyseNynja/bitcoin/libbitcoin'
  depends_on 'WyseNynja/bitcoin/obelisk'

  def install
    # we depend on gcc48 for build, but the PATH is in the wrong order
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"

    # todo: very likely need to include some things here

    # this is set in libbitcoin.pc.in
    ENV.cxx11

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end
end
