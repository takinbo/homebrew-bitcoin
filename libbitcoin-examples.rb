require 'formula'

class LibbitcoinExamples < Formula
  homepage 'https://github.com/spesmilo/libbitcoin'
  url 'https://github.com/spesmilo/libbitcoin.git', :tag => 'v1.4'
  head 'https://github.com/spesmilo/libbitcoin.git', :branch => 'master'

  depends_on 'pkg-config' => :build

  depends_on 'watch'
  depends_on 'WyseNynja/bitcoin/boost-gcc48' => 'c++11'
  depends_on 'WyseNynja/bitcoin/leveldb-gcc48'
  depends_on 'WyseNynja/bitcoin/libbitcoin'

  def install
    # we depend_on gcc48 (with -std=c++11), but PATH is in the wrong order so be explicit
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"
    ENV.cxx11

    cd "examples" do
      system "make"

      for script in [
        "accept",
        "balance",
        "blocks.sh",
        "connect",
        "determ",
        "display-last",
        "fullnode",
        "initchain",
        "priv",
        "proto",
        "satoshiwords",
        "txrad",
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
