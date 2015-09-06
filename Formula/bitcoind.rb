class Bitcoind < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.11.0.tar.gz"
  sha256 "2bcd61a4c288e5cc5d7fbe724606c610a20037332b06f7a9e99c1153eef73aef"
  
  head do
    url "https://github.com/bitcoin/bitcoin.git"
    
    depends_on "libevent"
  end

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :xcode => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "openssl"
  depends_on "miniupnpc" => :recommended

  if build.with? "gui"
    depends_on "qt5"
    depends_on "protobuf"
    depends_on "qrencode"
    depends_on "gettext" => :recommended
  end

  def install
    args = ["--prefix=#{libexec}", "--disable-dependency-tracking"]

    if build.with? "gui"
      args << "--with-qrencode"
      args << "--with-gui=qt5"
    end

    args << "--without-miniupnpc" if build.without? "miniupnpc"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "check"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
