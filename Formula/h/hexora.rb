class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "b07560b2424dc383981596b424ea235d0003121fa410235a953961b3b20208dd"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a37b6a420110d7ee626634e6f858897c2b5bcb1675637b0acd232bf504c5c20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae4686c81b9d43dbfb27172b6f9e528cd07ec99792acf06a7d95311fd6a05b34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eb7f92936e65487ab758c723e149422096432893dbc43fa416bf93a4f8fb5c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421cd168592f68d3966be7d56cd065a5dfeaa8718629cdf757e6e8d2e3628b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf819e985c9f0ab444bd3e7e27a20008d52725eae89890da593750bc8d97fa3d"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

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
