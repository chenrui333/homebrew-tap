class Macfan < Formula
  desc "Terminal UI for controlling Mac fan speeds via SMC on Apple Silicon"
  homepage "https://github.com/raminsharifi/MacFanControl"
  url "https://github.com/raminsharifi/MacFanControl/archive/1669877f01365fd1d948085ccbf4627691153c1b.tar.gz"
  version "0.1.0"
  sha256 "27df0c33e94c2297a0d2eb7d9941e9947241b144e2191fcfe7e13a2c067b2528"
  license "MIT"
  head "https://github.com/raminsharifi/MacFanControl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62fbfc80828dbd474e1f63819119905519f1d3f774b9b4988e86788dcb52cc79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a66c59af6207a3d906cb01d9bef796a9443e88ac27807e9e1ab615ce5a157e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f219ea4da26ecb7126323a425799327565cbc590f991e9378963d3cfe77279bd"
  end

  depends_on "rust" => :build
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/macfan --help")
    assert_match "fan", output
  end
end
