require 'formula'

class LibconfigGcc48 < Formula
  homepage 'http://www.hyperrealm.com/libconfig/'
  url 'http://www.hyperrealm.com/libconfig/libconfig-1.4.9.tar.gz'
  sha1 'b7a3c307dfb388e57d9a35c7f13f6232116930ec'

  keg_only "Conflicts with libconfig in main repository."

  option :universal

  def install
    # we depend on gcc48 for build, but PATH is in the wrong order so be explicit
    ENV['CC'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/gcc-4.8"
    ENV['CXX'] = ENV['LD'] = "#{HOMEBREW_PREFIX}/opt/gcc48/bin/g++-4.8"

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
