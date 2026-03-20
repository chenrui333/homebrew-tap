class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "d235c5eaf77551570670f4e4b6f8497b8089319a4078ea17d938c9f4cb288d68"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81efee193dd37cda2eb43a8a7a4cd04bb506681eaf1d58abbcc9e28091a340df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5eb624ac4e55bf2f1708c32f18cd28bc209d36a74081e0f26bba6a37e2e6e76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff98454087806f5dae5448eab1d88da4dae095d291670d4461fd209fc30f791a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50587f1f271e165acca14010bb9b76f87edfafcc8e7bbe570a0cf7ce4aed04b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18d71d79f88ed493cfde0b35801cd670dee4ad481ce0e6590d769824ab31a156"
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
