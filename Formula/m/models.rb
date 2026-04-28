class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "370604b5a1ca01d1aeb977870cc16d526c7d6e4803db51279979c4869707ea5c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a73aeaecc24509892224460fa876fa2002abeffb8e7f87260abbf6bf63d4c50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66bb4f11ece5fa65cfcbf029d896dfe44fbb431ebf7f0404cb5d9c1d29ee9411"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01682d92101eba4a46816a79d0a7a319ad1df572f726cf01cb64815401e90e05"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e91b2dbdb834650ecc59bdb1586d2f8d0a2100a38fd5c1020039e54aeeb69006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2827809c52ccf359a8da945273596677d40575e13e29f7a067346e9f4b687d8"
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
