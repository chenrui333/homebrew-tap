class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "eb752359ec57a1be1dbdac9bb09062e77e4340e8109dbdd516cbb607066dae6f"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f67a3ba42bfd439da7731b50d515622f4b3438ae86e6111a740812032bda65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a240ca2669cbc8feca7fe075dde57763ec4dadd0ca425b97c198aa12776a2e"
    sha256 cellar: :any,                 arm64_linux:   "5f5c2f847d71c06f35c5e382aa4891c6adeaa34b486ff327f6d200405e62b042"
    sha256 cellar: :any,                 x86_64_linux:  "c29b161e06e0a0514c8085081a4a3395569a40653318721f2ba5e7dc1f9ef595"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
