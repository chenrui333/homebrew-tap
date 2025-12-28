class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "27934aaacc9139357fb80916d03daaaa7abd567713bc560c935a19757d3a5676"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca5a60803edfabb0a1d90eb5a2646b196d13bc338d2ed815582980592e498a18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4369528087efa5cca0511bdef5387ebfed7a6016bf11093059510cfb2b8d1e7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58190eb0850859cf47f2e8a99c494197d0763bbd7f61b509c2836f5fb2572dae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33f7c74fd081e92c3caaa04d0dfd5d800440159810d0d08f3bad01eb65ac4b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9122991933e9117ef93e4c8f99d6903b9361ac2dcee034cd144010e91f1c8367"
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
