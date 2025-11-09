class Envx < Formula
  desc "Powerful and secure TUI environment variable manager"
  homepage "https://github.com/mikeleppane/envx"
  url "https://github.com/mikeleppane/envx/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d6c53b29acd23760c78c56d5a8f35589187b5fbf13859ee5c95dd8733b1b652c"
  license "MIT"
  head "https://github.com/mikeleppane/envx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "488870b521a979ab9bfeddee6795c0787f5eb97e021510ca2213f649b7cf79b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaa740ebfc2b2d724ba4455c7c12227b216a190291e2524e50af03194c4f35f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4454fb1da4f404b054e023a0903b999cf8c963bd8fb6407de034c1f73b692f26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a1ca7678d0882f9839d340e4c509b77a3301950b1ea52a24d443b6fecb12b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d854eb7b17372d6909859e415b92aa399a914313ae3ec3941c502c20ef76a6d6"
  end

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
