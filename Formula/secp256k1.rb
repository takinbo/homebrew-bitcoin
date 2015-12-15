class Secp256k1  < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin/secp256k1"
  head "https://github.com/bitcoin/secp256k1.git", :revision => "3026daa095797ffb5371ecf19bbd1de3d3b3eeb7"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl"

  def install
    system "./autogen.sh"
    system "./configure", "prefix=#{prefix}", "--disable-silent-rules", "--enable-module-recovery"
    system "make", "install"
  end
end
