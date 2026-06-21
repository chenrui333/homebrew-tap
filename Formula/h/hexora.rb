class Hexora < Formula
  desc "Static analysis of malicious Python code"
  homepage "https://github.com/rushter/hexora"
  url "https://github.com/rushter/hexora/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b64bb7fae5095bba021d79803fcea850912a386f99600e6c4ca4310a4fcaf7f8"
  license "MIT"
  head "https://github.com/rushter/hexora.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dbc2a3c440bd948dcffcd562ac89d0f08c13bb322d4cb208ac88186f00b0516"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25b1a17d5cb2cfb47b77464b3f6d6c6dc4e3daf8c04d7a3215de16f2c40aaf67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e222c8a7790d7878a3d9b8594884e2dc3966e58327a0f575cc7a14b3ef765f25"
    sha256 cellar: :any,                 arm64_linux:   "f92f151d24b5812242c09d53441302c92071a23930818d07b4b3f9d09da18193"
    sha256 cellar: :any,                 x86_64_linux:  "7095c1536baa88b7c78527f97c75718ca22c3502c5b855dfd8cb41adcdfdb8b8"
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
