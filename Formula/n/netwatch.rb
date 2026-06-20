class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.7.tar.gz"
  sha256 "c363a044118c870d96a50999a989033a4b662cf0800fcfc8deb948bee99b0b2e"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f4950017ae9a0629132dec227d79da25544d7b1361d2c52f5480d13ebedf88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84915766d4c3bd3b01711aece293e2ad5b59ceb2f8cdb57df579910450fe3a35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9370f0a1d0f549f64e858dc3168a015a741807c29a1a5e93c8e8fd3fd01e59b9"
    sha256 cellar: :any,                 arm64_linux:   "c31932c30bb618faba64bab47224223012b3385b3ed9bf04ceadc7a95ca42215"
    sha256 cellar: :any,                 x86_64_linux:  "3a0b51475b780e5fd7106884a937873f0d4db5006d576e4346c1a6ff1575723e"
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
