require 'formula'

class Vanitygen < Formula
  homepage 'http://github.com/WyseNynja/vanitygen'
  head 'https://github.com/WyseNynja/vanitygen.git'
  url 'https://github.com/WyseNynja/vanitygen.git', :tag => '0.23-red'
  version '0.23-red'

  option 'without-ocl', "Don't build oclvanitygen or oclvanityminer"

  depends_on 'curl' if build.with? 'ocl'  # todo: require with-ssl on curl?
  depends_on 'openssl'
  depends_on 'pcre'

  def install
    binaries = [
      'keyconv',
      'vanitygen',
    ]
    binaries << 'oclvanitygen' if build.with? 'ocl'
    binaries << 'oclvanityminer' if build.with? 'ocl'

    binaries.each do |binary|
      system "make", binary
      bin.install binary
    end
  end
end
