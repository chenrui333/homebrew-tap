class LibX < Formula
  desc "Browse your calibre library from the terminal"
  homepage "https://github.com/Benexl/lib-x"
  url "https://github.com/Benexl/lib-x/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "979016ccf86f2d150b6ca7ffa849fb38c75a35026e5cec5b17fe9dcb0eadc661"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f99528ccd0f1c6500e9abd0e7ffb8459a07d85b50855e06e35235c8367745dec"
  end

  deny_network_access!

  def install
    bin.install "lib-x"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lib-x --version")

    output = shell_output("#{bin}/lib-x --generate-desktop-entry")
    assert_match "Exec=#{bin}/lib-x --preferred-selector rofi", output
    assert_path_exists testpath/".config/lib-x/lib-x.conf"
  end
end
