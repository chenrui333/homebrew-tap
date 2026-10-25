class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.38.0.tar.gz"
  sha256 "f64ed60a7b5fb67679b7eb24ffedc1a20ab80546e588c8b943c06cd2e7fd0900"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce010c4edfe2d9f43193a3a60c93f8d006fb617a3bfb0c992d50625100a813c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e538f9df832892a1d01337a1403a9c926173dddbd9cedce77823f7cd71e977ce"
    sha256 cellar: :any,                 arm64_linux:   "02af969a48918e1d183713b4fa529aaf841a2170e47057b01e924d85819ad54f"
    sha256 cellar: :any,                 x86_64_linux:  "98354ce37aab02a992784b2d18f37a76a9549f0118a17eb5b89f8b5689493362"
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
