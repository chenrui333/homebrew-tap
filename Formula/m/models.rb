class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "e7b7955c6288b31c95ca66838f0d8ba129de8259a3ea65fa8044b32315d5bd2c"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ef1dc15a22a15160fd4ba30fb0bcaf731d82d2179ca329607faaab712f32b35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db070e69e5e946667d5bace67fe7a5374f2a10d2533c290bf8b1e87f2b3eb485"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbde7c2a1651344c3c2ff7a3053724d91c59f6fd713f9d9dc4c60245252276aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dae88341899d97f755975f04ad8aa87868e209ef9bec45dfd82f0e80c4c01960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c727344928393b86d89966a3eb7f025d8153eed2c0c6d144950af13153c1ba8"
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
