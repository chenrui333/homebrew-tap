class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0a5ec5fbdc59c25d2d84a90626a47c36203817f8dc82301051888f3e528d5910"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "741c72818b2bde249077992bf39c2f6b9a524f4e753d4d983417cd93067e436a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18937037791a7791d55957feca3272d1cfdc2e178713b3a64e7db108eb579c6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e1afbca41377950ebe7e2c348325e3bd193ad8c2e222d63a2795eb0d731bd9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c962057393058fb881c8a76eb93845899c27f4b638e7de3997c39297dcd251c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec03448402f6979ad9c7ca611eb5b7a2977dcf459f1460a6334de238182cf54a"
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
