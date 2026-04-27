class Snipt < Formula
  desc "Powerful text snippet expansion tool"
  homepage "https://github.com/snipt/snipt"
  url "https://github.com/snipt/snipt/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "a83d47c564e69c5805d4d99c3daa09ddee342d19c6df69f40e0fb6deb8647ade"
  license "MIT"
  head "https://github.com/snipt/snipt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "378f31ee8af8f9e145e2cfc6f57ec09dfd85563304a3e52a4ba9b1e05b80a14b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98a68b23d5df305214fb8498383b0387af19526948131c290d9bb4c6350bb691"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2761f232e421cba0ae648ea35f4bcf7fb6e1c2eb3b070d9069e0b83d7a0de31a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f543404f3592e889a65f0267629765c9cc87ab8af506ce1b00c56464a8b2cb9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b41ab2d47a5513c3ee6fbcc4bdbcf03b7ceea050eb30fd4dfac9cb90449ecad"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxi"
    depends_on "libxtst"
    depends_on "xdotool"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/snipt-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snipt --version")
    assert_match "snipt daemon is not running", shell_output("#{bin}/snipt status")
    assert_match "Database not found", shell_output("#{bin}/snipt list 2>&1", 1)
  end
end
