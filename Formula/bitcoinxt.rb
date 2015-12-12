class Bitcoinxt < Formula
  desc "A decentralized, peer to peer payment network"
  homepage "https://bitcoinxt.software/"
  url "https://github.com/bitcoinxt/bitcoinxt/archive/v0.11D.tar.gz"
  version "0.11D"
  sha256 "66b4bd52ed8b97e28da46ac552396c40853a9d7f765063603552e1cf118a2227"

  head do
    url "https://github.com/bitcoinxt/bitcoinxt.git"

    depends_on "libevent"
  end

  conflicts_with "bitcoind", :because => "bitcoind also ships a bitcoind binary"

  option "with-gui", "Build the GUI client (requires Qt5)"

  depends_on :macos => :lion
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
    end

    args << "--without-miniupnpc" if build.without? "miniupnpc"

    system "./autogen.sh"
    system "./configure", *args

    system "make"
    system "make", "install"
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end
end
