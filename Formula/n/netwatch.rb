class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "db9110535dfcde9ccb8736706465216932308499ab087f67e3f633decab32e04"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2788ad4ffdeb35d552a7f7fd03497a7b6eb3d90f6fef86a1516d8d0fde1c1b36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7dbbbe2a66b121b62f7c8d2b79a34427281a3b58fb1279f248ee0fc8c084f74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41c8fff9efdbbff2c5f832bf2d98da68bc631e11699652fa9be8af20a3350df2"
    sha256 cellar: :any,                 arm64_linux:   "ed95c7a79a1a0d8d5de5ac09a9a6967557cde7befffa657651441616b64c32cd"
    sha256 cellar: :any,                 x86_64_linux:  "688acdb2bbe9eeb40d3cc69d2c4383fdec6f3a658d4689e7b6fcc573ac268c56"
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
