class Rawhide < Formula
  desc "Find files using pretty C expressions"
  homepage "https://raf.org/rawhide/"
  url "https://github.com/raforg/rawhide/releases/download/v3.3/rawhide-3.3.tar.gz"
  sha256 "a51a1360ce4763838b29a548a8e49dcf47a93a922bf1df05c8b7d50ecb9ab09d"
  license "GPL-3.0-or-later"

  on_linux do
    depends_on "pcre2"
  end

  def install
    system "./configure", "--prefix=#{prefix}"

    inreplace "Makefile" do |s|
      s.gsub!(/^PREFIX\s*=\s*.*$/, "PREFIX = #{prefix}")
      s.gsub!(/^ETCDIR\s*=\s*.*$/, "ETCDIR = #{etc}")
    end

    system "make"
    system "make", "install-bin"
    system "make", "install-man"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rh --version")
  end
end
