class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.28.1.tar.gz"
  sha256 "db428f9a85b930a37da33e2bd3ff9dd13c867de3e222e70a20c29e2fd3d5378e"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c11984dbe6ed514552fc1c90fef690d0857feb80b87713498b881c63606e23d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2304523e63641520fc56be3518aae045098963094f6b2fb16ed0938ec844991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad439444076972ac04e4a657ff981e73d837c2623dc8ccce2f313a199461574"
    sha256 cellar: :any,                 arm64_linux:   "35d6e87739f63a8ea7355d0102203f986b527266ce977fe2551edf7c4cfa1e74"
    sha256 cellar: :any,                 x86_64_linux:  "4712d9e95c4b036ba1eb1e6d4bace87588a369d8c82cb63b6dd4ea326365cbe9"
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
