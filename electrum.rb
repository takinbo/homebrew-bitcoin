require 'formula'

class Electrum < Formula
  homepage 'http://electrum.org/'
  url 'https://github.com/spesmilo/electrum.git', :tag => '1.9.8'
  head 'https://github.com/spesmilo/electrum.git', :tag => 'master'

  depends_on 'ecdsa' => :python
  depends_on 'pycurl' => :python
  #depends_on 'slowaes' => :python  # must be installed with pip install --pre slowaes
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

  def caveats
    "You must also run `pip install --pre slowaes`"
  end

end

__END__
