class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "7286be425fa547931d1a769487f1c56c31fc8e52f23d4703a8fc367b4b84e706"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3f037183d904599b3ba7cfacb8c870b8c4b8fff6922cf655ac0115fc270f814"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d77c160aff2c7427f323115f1aeb69d6a4c516f4888b5efdb4b7f7ba42bbd86"
    sha256 cellar: :any,                 arm64_linux:   "550bf87f30f7f1ea7f10b0b3532da2b3d726fde5a29b2112e83e460bcaca28b9"
    sha256 cellar: :any,                 x86_64_linux:  "514dafeede7af285207d9c55b72b9e77d0091c8a3500a0849a8176aeaa3a4f7e"
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
