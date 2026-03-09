class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "e7b7955c6288b31c95ca66838f0d8ba129de8259a3ea65fa8044b32315d5bd2c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82b1436f86f329871656b8a816907de215b5924e951081a5e4024554d6c44431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "324324d2501e8277c977b71216867579ef0acc59693676e27d7e26324ea9131e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71092993844cf67ee5c70321855c989134461ecfab260ffd0c2f8dd8dd9362c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88dc86005b12187e825dc69ff97d0a444597db8a6ba6eb701312249bc7018ad7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cdd981a78eaa9df741c99aa41c689d9f193a8979459cdf2874f6e53ccb60cd2"
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
