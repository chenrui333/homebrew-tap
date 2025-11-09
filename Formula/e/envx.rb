class Envx < Formula
  desc "Powerful and secure TUI environment variable manager"
  homepage "https://github.com/mikeleppane/envx"
  url "https://github.com/mikeleppane/envx/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d6c53b29acd23760c78c56d5a8f35589187b5fbf13859ee5c95dd8733b1b652c"
  license "MIT"
  head "https://github.com/mikeleppane/envx.git", branch: "main"

  depends_on "rust" => :build

  def install
    rm ".cargo/config.toml"
    system "cargo", "install", *std_cargo_args(path: "crates/envx")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envx --version")
    assert_match "Environment Variables Summary", shell_output("#{bin}/envx list")
    assert_match "Available project templates", shell_output("#{bin}/envx init --list-templates")
  end
end
