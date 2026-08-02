class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "7286be425fa547931d1a769487f1c56c31fc8e52f23d4703a8fc367b4b84e706"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f82a517308c910258bc171ea57afce78bd2ab870519692b922241f3e8682402"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa56e5d5d3280b9114c58577f9a445ed2d5a107b8d7ca65bdb1e8989efb6c9e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f590d75c5732d0be7b782afddfb97f1203ddcbba4fb314834a32a9f95711aaa"
    sha256 cellar: :any,                 arm64_linux:   "04fbd7b42bd68f0a04d2dd4eff2184c1c2c2005dfa637873072a365b6c063191"
    sha256 cellar: :any,                 x86_64_linux:  "27c150b4d51bc09b276ec8c1f847e087ef87e352d66866e166c8bda668ed7c75"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/hexora")
  end

  test do
    output = shell_output("#{bin}/hexora rules")
    assert_match "| HX2000 | ClipboardRead | Reading from the clipboard. |", output

    # Create a minimal Python file that should trigger HX2000 (clipboard read)
    (testpath/"bad.py").write <<~PY
      import pyperclip
      data = pyperclip.paste()
    PY

    out = shell_output("#{bin}/hexora audit --output-format terminal bad.py")
    assert_match "HX2000", out
    assert_match "clipboard access can be used to exfiltrate sensitive data", out.downcase
  end
end
