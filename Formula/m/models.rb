class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "d235c5eaf77551570670f4e4b6f8497b8089319a4078ea17d938c9f4cb288d68"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bcef0b0bda0cf66cc3185fa4e7f359f2a17f54d144a86b3e06b272bb7446b70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4af411675939654dd27101b1da50ccdc5d64abbae78bfb62573cc9168bee575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46740d3e0a9a714205b502db2c063bffd375f59992d7ae4a4c0b4ad6fc670ed8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b819a5d6fafcd91a9946de365c229955ab6d2a2cd49855630115b9bcffd15056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28e61c14daefac7df18940705ac90cc341028336cfa3788d4a7b2e39cb321c2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"models" => "agents"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/models --version")

    output = shell_output("#{bin}/agents list-sources")
    assert_match "Claude Code", output
    assert_match "Codex", output
  end
end
