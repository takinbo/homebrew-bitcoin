require 'formula'

class BitcoindSipaWatchonly < Formula
  homepage 'http://bitcoin.org/'
  url 'https://github.com/sipa/bitcoin.git', :branch => 'watchonly'
  version '0.8.99.0'

  depends_on 'automake'
  depends_on 'berkeley-db4'
  depends_on 'boost'
  depends_on 'miniupnpc' if build.include? 'with-upnp'
  depends_on 'openssl'
  depends_on 'pkg-config'
  depends_on 'protobuf'

  option 'with-upnp', 'Compile with UPnP support'
  option 'without-ipv6', 'Compile without IPv6 support'

  def install
    system "sh", "autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--without-qt"
    system "make"
    system "strip src/bitcoind"
    bin.install "src/bitcoind"
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
          <string>#{opt_prefix}/bin/bitcoind-sipa-watchonly</string>
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

      If you are using this for coinpunk, you will need to add a couple more options.

      echo -e "txindex=1\\ntestnet=1" >> ~/Library/Application\\ Support/Bitcoin/bitcoin.conf

      You will probably need to "brew unlink bitcoind; brew link bitcoind-sipa-watchonly"
    EOS
  end
end

__END__
