class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "9bb24235bb5deddd73ead028a51cdc7c7bcb0993d0fc254af37a194f13fce56e"
  license "MIT"
  revision 1
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d0e0ee99bffa9919461166aa0bb9364f0c8352ff183068f5d080de264842d6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad2b036d4b4e0ed464c7c4722110d1b2ff2ff5c804c0e7f96d7d8ad6c10f4612"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ddd43e2633f6402c8bc1dd7754d6d9ad899b8398768c522948bd14095c01a52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a0e6a4814810a38f604bc65ef23b43dfaf5bfe383ec42861f86732800967f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62aab26e164245659b6d423219ec3bc69a5d69a91c21d0853628f0e1fe47c76a"
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
