class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.4.tar.gz"
  sha256 "0a5697327926d54b0c8b0b0ea6ad99ee718a0cfd4bd872b70a08b191221ae0ef"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c6760f91c4d49c8b7a3e9f3708089b56283e767be33355465bf9a2b78d5070c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d7bd83a71493f78d6577f77eaeffada87aa9472da5bfcaf229d00203a16af4a"
    sha256 cellar: :any,                 arm64_linux:   "4f5cfd8e01ab35aeea9ea0c0e973541e13a5d12b4f81e96fb91ebaa02db1a8d8"
    sha256 cellar: :any,                 x86_64_linux:  "2c232b49274d538c3c987230aac4040cd5a4879e49715690c3d99023047ce0e9"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
