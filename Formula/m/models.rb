class Models < Formula
  desc "CLI and TUI for browsing AI models and coding agents"
  homepage "https://github.com/arimxyer/models"
  url "https://github.com/arimxyer/models/archive/refs/tags/v0.9.8.tar.gz"
  sha256 "29e58ef1885f035853c8129e92c0ba6c998359ca31077e3d55934c37a3065195"
  license "MIT"
  head "https://github.com/arimxyer/models.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72341c365f72a999eda79bbd6a1c0af8288b5ef01b85818f908bb907d05cdd22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6465d7741fc83b052a32fde8f9027f6a6d524ee081583bdbc5cdba32592240de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ab4a7b1916774a5aae406e0ab9d9575c775b2728f0678baa666cb61e49de4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f7c7242d11765bdac48ae0f98268d045f4ea00580fd7bb926c72b73b9123b40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7105dbe436d3e5dd54a70923700245fc64709823482d25cb44cfd23c22b5b9c"
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
