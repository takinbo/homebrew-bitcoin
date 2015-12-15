class Libbitcoin  < Formula
  desc "Bitcoin Cross-Platform C++ Development Toolkit https://libbitcoin.org/"
  homepage "https://github.com/libbitcoin/libbitcoin"
  head "https://github.com/libbitcoin/libbitcoin.git", :branch => "version2"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "secp256k1" => :build
  depends_on "boost" => :build

  def install
    system "./autogen.sh"
    system "./configure", "prefix=#{prefix}"
    system "make", "install"
  end
end
