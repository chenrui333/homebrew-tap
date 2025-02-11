class LibX < Formula
  desc "Browse your calibre library from the terminal"
  homepage "https://github.com/Benexl/lib-x"
  url "https://github.com/Benexl/lib-x/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "979016ccf86f2d150b6ca7ffa849fb38c75a35026e5cec5b17fe9dcb0eadc661"
  license "GPL-3.0-or-later"

  def install
    bin.install "lib-x"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lib-x --version")

    # TODO: fix test
    # output = shell_output("#{bin}/lib-x --search tag:chess 2>&1", 1)
    # assert_match "calibredb: command not found", output
  end
end
