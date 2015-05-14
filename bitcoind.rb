class Bitcoind < Formula
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin.git", :tag => "v0.10.1"
  head "https://github.com/bitcoin/bitcoin.git", :branch => "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db4"
  depends_on "boost"
  depends_on "openssl"

  depends_on "miniupnpc" => :optional
  deprecated_option "with-upnp" => "with-miniupnpc"

  option "without-utils", "Build without utilities (bitcoin-cli & bitcoin-tx)"

  option "with-gui", "Build GUI client (requires Qt)"
  if build.with? "gui"
    depends_on "qt"
    depends_on "protobuf"
    depends_on "qrencode"
  end

  option "without-check", "Disable build-time checking"

  def install
    system "./autogen.sh"

    args = []
    args << "--without-miniupnpc" if build.without? "miniupnpc"
    args << "--without-utils" if build.without? "utils"
    args << "--without-gui" if build.without? "gui"
    system "./configure", "--prefix=#{prefix}", *args

    system "make"
    system "make", "check" if build.with? "check"

    cd "src" do
      system "strip", "bitcoind"
      bin.install "bitcoind"

      if build.with? "utils"
        system "strip", "bitcoin-cli", "bitcoin-tx"
        bin.install "bitcoin-cli", "bitcoin-tx"
      end

      if build.with? "gui"
        system "strip", "qt/bitcoin-qt"
        bin.install "qt/bitcoin-qt"
      end
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
          <key>PathState</key>
          <dict>
            <key>~/Library/Application Support/Bitcoin/bitcoind.pid</key>
            <false/>
          </dict>
        </dict>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/bitcoind</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    You will need to setup your bitcoin.conf if you haven't already done so:

    echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\\ Support/Bitcoin/bitcoin.conf
    chmod 600 ~/Library/Application\\ Support/Bitcoin/bitcoin.conf

    Use `bitcoind stop` to stop bitcoind if necessary! `brew services stop bitcoind` does not work!
    EOS
  end
end
