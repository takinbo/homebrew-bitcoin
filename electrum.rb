require 'formula'

class Electrum < Formula
  homepage 'http://electrum.org/'
  url 'https://github.com/spesmilo/electrum.git', :tag => '1.9.7'
  head 'https://github.com/spesmilo/electrum.git', :tag => 'master'

  depends_on :python => 'ecdsa'
  depends_on :python => 'slowaes'
  depends_on 'qt'
  depends_on 'pyqt'
  depends_on 'gettext'

  def install
        system "python", "mki18n.py"
        system "pyrcc4", "icons.qrc", "-o", "gui/qt/icons_rc.py"
        system "python", "setup.py", "install", "--prefix=#{prefix}", "--single-version-externally-managed", "--record=installed.txt"
  end

  test do
	system "false"
  end

end

__END__
