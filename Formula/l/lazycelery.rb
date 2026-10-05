class Lazycelery < Formula
  desc "High-performance TUI for Docker container management"
  homepage "https://github.com/fguedes90/lazycelery"
  url "https://github.com/Fguedes90/lazycelery/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "5e9ec7fa7285678eb07fdf88cd9147fb6ed0ec1e77df6f1204661e2275114966"
  license "MIT"
  head "https://github.com/Fguedes90/lazycelery.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36b695847b547888bf5197ea88f8b0b758c860710b19d0edf1a2929f1d23f7f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecf16077d3d960327c33e6f1cf27eed7750d65bb6cfb8a3f7ac060e7ea59a68e"
    sha256 cellar: :any,                 arm64_linux:   "0180beb5ca9a9690bcbea26df8bb416e892b9c4a7393656a78e0f919306aa2ae"
    sha256 cellar: :any,                 x86_64_linux:  "122e3a27c683d5035d495e5b2af3c1c91bd96bbd1500287d228c506f4c1068c6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazycelery --version")
    assert_match "No configuration found.", shell_output("#{bin}/lazycelery config 2>&1")
  end
end
