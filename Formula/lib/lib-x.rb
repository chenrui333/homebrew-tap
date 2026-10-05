class LibX < Formula
  desc "Browse your calibre library from the terminal"
  homepage "https://github.com/Benexl/lib-x"
  url "https://github.com/Benexl/lib-x/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "979016ccf86f2d150b6ca7ffa849fb38c75a35026e5cec5b17fe9dcb0eadc661"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b338dc39294385300871336801cf4688022dce9555fc7b7823dbc9ad07e1e6db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d33e206c7dc786d97d99e2c33828d9fbca74250e79e00f165d7ac668e7cdb7"
    sha256 cellar: :any_skip_relocation, ventura:       "c8572b7cafc3b8cb8ea3295d655e55b95d04beb3a29ba1829c9c8dd7f3adfabd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1aa257f6754a5b2b41b3b1be169b4acdb5657fe53a8f3cb55e816591aa39e2f2"
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
