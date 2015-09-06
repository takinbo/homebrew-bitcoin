class Electrum < Formula
  desc "Lightweight bitcoin wallet"
  homepage "https://electrum.org/"
  url "https://github.com/spesmilo/electrum/archive/2.4.3.tar.gz"
  sha256 "0564054651f81d53985ecc2e4e902e0a4a5fcbbabb6b716a2d0f474371a920b7"

  head "https://github.com/spesmilo/electrum.git"

  depends_on "qt"
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pyqt"
  depends_on "gettext"
  depends_on "protobuf"
  depends_on "qrencode"

  resouce "slowaes" do
    url "https://pypi.python.org/packages/source/s/slowaes/slowaes-0.1a1.tar.gz"
    sha256 "83658ae54cc116b96f7fdb12fdd0efac3a4e8c7c7064e3fac3f4a881aa54bf09"
  end

  resource "ecdsa" do
    url "https://pypi.python.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "pycurl" do
    url "https://pypi.python.org/packages/source/p/pycurl/pycurl-7.19.5.1.tar.gz"
    sha256 "6e9770f80459757f73bd71af82fbb29cd398b38388cdf1beab31ea91a331bc6c"
  end

  resource "dnspython" do
    url "https://pypi.python.org/packages/source/d/dnspython/dnspython-1.11.1.zip"
    sha256 "fd0fc7a656679a6fd1f83d980fc05776c76e70d66f6ee2aab12a3558fa10a206"
  end

  def install
        system "pyrcc4", "icons.qrc", "-o", "gui/icons_rc.py"
        system "protoc", "--protoc_path=lib/", "--python_out=lib/", "lib/paymentrequest.proto"
        system "./contrib/make_locale"
        system "python", "setup.py", "install", "--prefix=#{prefix}"
  end
end
