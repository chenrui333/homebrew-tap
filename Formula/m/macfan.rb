class Macfan < Formula
  desc "Terminal UI for controlling Mac fan speeds via SMC on Apple Silicon"
  homepage "https://github.com/raminsharifi/MacFanControl"
  url "https://github.com/raminsharifi/MacFanControl/archive/1669877f01365fd1d948085ccbf4627691153c1b.tar.gz"
  version "0.1.0"
  sha256 "27df0c33e94c2297a0d2eb7d9941e9947241b144e2191fcfe7e13a2c067b2528"
  license "MIT"
  head "https://github.com/raminsharifi/MacFanControl.git", branch: "main"

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
