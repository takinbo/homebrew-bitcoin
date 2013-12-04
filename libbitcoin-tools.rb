require 'formula'

class LibbitcoinTools < Formula
  homepage 'https://github.com/spesmilo/libbitcoin'
  url 'https://github.com/spesmilo/libbitcoin.git', :tag => 'v1.4'
  head 'https://github.com/spesmilo/libbitcoin.git', :branch => 'master'

  depends_on 'homebrew/versions/gcc48' => :build
  depends_on 'pkg-config' => :build

  depends_on 'curl'  # todo: not sure if this is needed
  depends_on 'openssl'
  depends_on 'watch'  # todo: not sure if this is needed
  depends_on 'WyseNynja/bitcoin/boost-gcc48' => 'c++11'
  depends_on 'WyseNynja/bitcoin/libbitcoin'
  depends_on 'WyseNynja/bitcoin/leveldb-gcc48'  # todo: not sure if this is needed

  #ENV['HOMEBREW_CC'] = 'gcc-4.8'
  #ENV['HOMEBREW_CXX'] = 'g++-4.8'

  def patches
    # fixup Makefile
    #DATA
  end

  def install
    ENV.prepend_path 'PATH', "#{HOMEBREW_PREFIX}/opt/gcc48/bin"
    ENV['CC'] = "gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "g++-4.8"
    ENV.cxx11

    cd "tools" do
      system "make"
      for script in [
        "bootstrap",
      ] do
        system "mv", script, "bitcoin-"+script
        bin.install "bitcoin-"+script
      end
    end
  end

  test do
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test libbitcoin`.
    system "false"
  end
end
