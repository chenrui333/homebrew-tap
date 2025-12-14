class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b07560b2424dc383981596b424ea235d0003121fa410235a953961b3b20208dd"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9a7cb5da8457fda0b9a1d1ac2d89c0bf76fc64775d6a39b2bf124f107aefbf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "397962f862cc861372383159e3bedeab25f30ce7441f9296cef3cdcc478cb0d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fdd00758a8a2d1237a3dc889cdbdddbd759e400083612f2b43fdb85fdfc0121"
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
