class Rawhide < Formula
  desc "Find files using pretty C expressions"
  homepage "https://raf.org/rawhide/"
  url "https://github.com/raforg/rawhide/releases/download/v3.3/rawhide-3.3.tar.gz"
  sha256 "a51a1360ce4763838b29a548a8e49dcf47a93a922bf1df05c8b7d50ecb9ab09d"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 arm64_tahoe:   "f13b1b1968906f8a71353bfa28b74cbbbbd79e58e6bc0a5dbebc98c0630c4009"
    sha256 arm64_sequoia: "8d415467fbe8ae38465927213529e52f30ea97ba82379938eae9bbcca7f68730"
    sha256 arm64_linux:   "974950ef27a03c62158dd8819050b0461703c4ee15e53d7d0ccb61f2b2b4eb2b"
    sha256 x86_64_linux:  "8d231d5cfa3aadf713fc5900745a39c6918b369838ea94634c7304a263d65b90"
  end

  on_linux do
    depends_on "pcre2"
  end

  deny_network_access!

  def install
    system "./configure", "--prefix=#{prefix}"

    inreplace "Makefile" do |s|
      s.gsub!(/^PREFIX\s*=\s*.*$/, "PREFIX = #{prefix}")
      s.gsub!(/^ETCDIR\s*=\s*.*$/, "ETCDIR = #{etc}")
    end

    system "make"
    system "make", "install-bin"
    system "make", "install-man"
    etc.install "rawhide.conf"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rh --version")

    ENV.delete "RAWHIDE_CONFIG"
    (testpath/"fixtures/skip.txt").mkpath
    (testpath/"fixtures/keep.txt").write "match\n"
    (testpath/"fixtures/skip.log").write "ignore\n"

    assert_equal "fixtures/keep.txt\n", shell_output("#{bin}/rh -n -e 'file && f && \"*.txt\"' fixtures")
    assert_equal "fixtures/skip.txt\n", shell_output("#{bin}/rh -n -e 'dir && d && \"*.txt\"' fixtures")
  end
end
