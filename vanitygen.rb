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

    if build.with? 'ocl'
      binaries << 'oclvanitygen'
      binaries << 'oclvanityminer'
    end

    binaries.each do |binary|
      system "make", binary
      bin.install binary
    end

    # we need these for ocl to work
    include.install Dir['*.cl']
  end

  def caveats; <<-EOS.undent
    You must run oclvanitygen and oclvanityminer from #{opt_prefix}/include
    EOS
  end
end
