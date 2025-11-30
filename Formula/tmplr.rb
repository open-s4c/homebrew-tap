class Tmplr < Formula
  desc "Simple template replacement tool for C projects"
  homepage "https://github.com/open-s4c/tmplr"
  url "https://github.com/open-s4c/tmplr/archive/refs/tags/v1.4.tar.gz"
  sha256 "ab6b67cd9894afbd8f262a7739598902c873c89007bcddb818afe65b405294ea"
  license "0BSD"

  def install
    system "make"
    bin.install "tmplr"
    man1.install "tmplr.1"
    include.install "include/tmplr.h"
  end

  test do
    system "#{bin}/tmplr", "-V"
  end
end
