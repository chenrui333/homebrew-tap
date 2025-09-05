class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "86de5c5ea4a7300876d22b79d4ce48e30b9ef2f537bf95c75df476ed540b24dd"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44efd8060ec8d4a99471c6f6cd57cb89fc1fcfe720abf944dff4ae3ed3997d9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c1fc0b16de4138a6ddc9d713ac953e35454c60cd378b883ce902e0d2071dcd7"
    sha256 cellar: :any_skip_relocation, ventura:       "283e3cf7e60622ae5286abe5ec1682ba2420d918c11ec69f79a55b4ff86da1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3c0f1eeae04334ef7ce15e8c3f45ec4d171a7af192cebcb2920c35f5a641b68"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
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
