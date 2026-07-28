class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "db428f9a85b930a37da33e2bd3ff9dd13c867de3e222e70a20c29e2fd3d5378e"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49843317dd2c890dd7902efda75106930a37639e29e64b3f58fa87cbc6b32f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e79616095249551068f81be849591640b8736f167e0a59ef2bb968792a7e4c01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b582f3393b181bae9f7f5d4523dd67631b49a64c106d95c278e168fc29b2ea"
    sha256 cellar: :any,                 arm64_linux:   "b5aec0c109558400c290a2d183bc3ee724d7fa9e21fc23d8ceeb40539de9e490"
    sha256 cellar: :any,                 x86_64_linux:  "de914384aebe148a105afeffd5389e50fae41a773fbb24d19c3e385dd6c2a4e0"
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
