class Rustormy < Formula
  desc "Minimal neofetch-like weather CLI"
  homepage "https://github.com/Tairesh/rustormy"
  url "https://github.com/Tairesh/rustormy/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "f8b5b8e47c5d03eaefd544eed6a7b1f33494e4c36ccaa57edbe3881780f431b1"
  license "MIT"
  head "https://github.com/Tairesh/rustormy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f0488831877cfb746032fc6740e9406e16d45f5ddd11d72ca3e1ca2aeec5525"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cddcf40975bc8d15fea74abf9da8dd776f9c6e93f7419638a149c2d8667aeebc"
    sha256 cellar: :any,                 arm64_linux:   "0323866fcc1b359a5f888c9b5d89f2b951574a20e42f19bad01ef82c94f314fb"
    sha256 cellar: :any,                 x86_64_linux:  "8c0389088d7a73dc30eb1d94a4fca91f575c42a53974e68f82935ffc8b7277fb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustormy --version")
    assert_match "Cache cleared successfully.", shell_output("#{bin}/rustormy --clear-cache")
  end
end
