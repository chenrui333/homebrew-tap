class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "e67ba46ba7bebc4914c34a4f5a1a22f3d3e57bd6bdb07ec035667cd1751e968a"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4431a4bd2b1e36eda35861fea73dce327017c4d7635d56b96249b9019f620cb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5080f1ecca5c0acaec2d39668a1b45b8c85fc400a410885dffa42d37748beb1"
    sha256 cellar: :any,                 arm64_linux:   "6a1c9023e8ed0ee17297f438243c7710753b3529e90b6a86f6f33b8f7fb2c165"
    sha256 cellar: :any,                 x86_64_linux:  "d1fda39ca18f0d1bec236192ce6d0671c8ff4f953ccded988f1aac70000d662c"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
