class Fnc < Formula
  desc "Interactive text-based user interface for Fossil"
  homepage "https://fnc.sh/home"
  url "https://fnc.sh/uv/dl/fnc-0.18.tar.gz"
  sha256 "49f94c67e00213440d84f3b09bcf75850f9b6e8d8721856d68f4596c49cec780"
  license "ISC"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fnc --version")
    assert_match "fnc: no work tree or repository found", shell_output("#{bin}/fnc 2>&1", 1)
  end
end
