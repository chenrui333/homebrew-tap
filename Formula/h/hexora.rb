class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0a5ec5fbdc59c25d2d84a90626a47c36203817f8dc82301051888f3e528d5910"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55a9666e0781660049d78ea5fd0c06aac575c2bc33de996d1aa7c9d421ef02a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3d614dd19d0473b5e0d6c067225f2946e18ffda861cc946231bdb347c5cbff4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e0faba9b6dfded0f4d5ab352e1ddc5691b5ad0dca2d589efc83d708fdd72745"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4504a8862abb8eb8c8999d5a4884ef4dd47130112b34ab3dcce43efc98026b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "891f68eee3d23ef27258b0c4492bd980f3c7d7dc1537ee5ecdbeaa444a06fc26"
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
