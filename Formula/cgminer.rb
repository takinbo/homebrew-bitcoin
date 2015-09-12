class Cgminer < Formula
  desc "ASIC and FPGA miner in c for bitcoin"
  homepage "https://github.com/ckolivas/cgminer"
  url "https://github.com/ckolivas/cgminer/archive/v4.9.2.tar.gz"
  sha256 "50b93968410880a69f3c4e4b3758c5ed00162ab53ece87c53635313bcf82308a"

  option "with-ants1", "Compile support for Antminer S1 Bitmain"
  option "with-ants2", "Compile support for Antminer S2 Bitmain"
  option "with-avalon", "Compile support for Avalon"
  option "with-avalon2", "Compile support for Avalon2"
  option "with-avalon4", "Compile support for Avalon4"
  option "with-bab", "Compile support for BlackArrow Bitfury"
  option "with-bflsc", "Compile support for BFL ASICs"
  option "with-bitforce", "Compile support for BitForce FPGAs"
  option "with-bitfury", "Compile support for BitFury ASICs"
  option "with-bitmine_A1", "Compile support for Bitmine.ch A1 ASICs"
  option "with-blockerupter", "Compile support for ASICMINER BlockErupter Tube/Prisma"
  option "with-cointerra", "Compile support for Cointerra ASICs"
  option "with-drillbit", "Compile support for Drillbit BitFury ASICs"
  option "with-hashfast", "Compile support for Hashfast"
  option "with-icarus", "Compile support for Icarus"
  option "with-klondike", "Compile support for Klondike"
  option "with-knc", "Compile support for KnC miners"
  option "with-minion", "Compile support for Minion BlackArrow ASIC"
  option "with-modminer", "Compile support for ModMiner FPGAs"
  option "with-sp10", "Compile support for Spondoolies SP10"
  option "with-sp30", "Compile support for Spondoolies SP30"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "jansson"
  depends_on "curl" => :optional

  def install

    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
    ]

    args << "--enable-ants1" if build.with? "ants1"
    args << "--enable-ants2" if build.with? "ants2"
    args << "--enable-avalon" if build.with? "avalon"
    args << "--enable-avalon2" if build.with? "avalon2"
    args << "--enable-avalon4" if build.with? "avalon4"
    args << "--enable-bab" if build.with? "bab"
    args << "--enable-bflsc" if build.with? "bflsc"
    args << "--enable-bitforce" if build.with? "bitforce"
    args << "--enable-bitfury" if build.with? "bitfury"
    args << "--enable-bitcoin_A1" if build.with? "bitmine_A1"
    args << "--enable-blockerupter" if build.with? "blockerupter"
    args << "--enable-cointerra" if build.with? "cointerra"
    args << "--enable-drillbit" if build.with? "drillbit"
    args << "--enable-hashfast" if build.with? "hashfast"
    args << "--enable-icarus" if build.with? "icarus"
    args << "--enable-klondike" if build.with? "klondike"
    args << "--enable-knc" if build.with? "knc"
    args << "--enable-minion" if build.with? "minion"
    args << "--enable-modminer" if build.with? "modminer"
    args << "--enable-sp10" if build.with? "sp10"
    args << "--enable-sp30" if build.with? "sp30"

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

  end
end
