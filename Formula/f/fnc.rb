class Fnc < Formula
  desc "Interactive text-based user interface for Fossil"
  homepage "https://fnc.sh/"
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
    require "open3"

    output, status = Open3.capture2e(bin/"fnc", "--version")
    if status.success?
      assert_match version.to_s, output
    else
      assert_match "stdin is not a tty", output
    end

    output = shell_output("#{bin}/fnc 2>&1", 1)
    assert_match(/stdin is not a tty|no work tree or repository found/, output)
  end
end
