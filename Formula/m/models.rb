class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "c113821eba94b82d1e98f5590c8be1cb4aa39ecdf26bf9721a5ccbb704b433da"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "796e5c9e17a2782302558c68eecd672b20ea358a8ad0f44f21cc5b96602a7659"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc90f007748ede3d929ca4f56559a74ae8724db16a1f1417b6ddc9e7e928b57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98919cc0d4ed78bb025f03c75eda162f515c9e61b7a5428d7bcb8e3226fcb8ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4953a19279d67a8a1f3cfcf4a5be0976f18aa4ebf4fd5fd8e2fdeb56599b6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3538780ee116cf64372f738c799f72d1da5f7bd9c1feb8a26b049f1a83e63fe2"
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
