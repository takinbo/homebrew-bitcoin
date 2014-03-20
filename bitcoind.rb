require 'formula'

class Bitcoind < Formula
  homepage 'http://bitcoin.org/'
  url 'https://github.com/bitcoin/bitcoin.git', :tag => 'v0.9.0'
  version '0.9.0'
  head 'https://github.com/bitcoin/bitcoin.git', :branch => 'master'

  depends_on 'automake'
  depends_on 'berkeley-db4'
  depends_on 'boost'
  depends_on 'miniupnpc' if build.include? 'with-upnp'
  depends_on 'openssl'
  depends_on 'pkg-config'
  depends_on 'protobuf'

  option 'with-coinpunk', 'Compile with patches for coinpunk'
  option 'with-upnp', 'Compile with UPnP support'
  option 'without-ipv6', 'Compile without IPv6 support'

  def patches
    ps = []
    if build.with? 'coinpunk'
      # merge patch equivalent of https://github.com/bitcoin/bitcoin/pull/3383
      ps << 'https://gist.github.com/WyseNynja/8120948/raw/f651429ca271b781dc4083d88f0a351e3f2c0688/patch+for+coinpunk'
    end
    ps
  end

  def install
    system "sh", "autogen.sh"
    # todo: make --without-qt optional
    system "./configure", "--prefix=#{prefix}", "--without-qt"
    system "make"
    system "strip src/bitcoin-cli"
    system "strip src/bitcoind"
    bin.install "src/bitcoin-cli"
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
          <string>#{opt_prefix}/bin/bitcoind</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  def caveats
    cs = [<<-EOS.undent
      You will need to setup your bitcoin.conf if you haven't already done so:

      echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\\ Support/Bitcoin/bitcoin.conf
      chmod 600 ~/Library/Application\\ Support/Bitcoin/bitcoin.conf

      Use `bitcoind stop` to stop bitcoind if necessary! `brew services stop bitcoind` does not work!
      EOS
    ]

    if build.with? 'coinpunk'
      cs << <<-EOS.undent
        You will also need to add a couple more options for coinpunk.

        echo -e "txindex=1\\ntestnet=1" >> ~/Library/Application\\ Support/Bitcoin/bitcoin.conf
      EOS
    end

    cs
  end
end

__END__
