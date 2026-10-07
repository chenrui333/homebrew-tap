class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "8a77d43614faf35e30cfb86408917e2362fbd2486f41bef0ceb9c66ec0f185be"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c925c60badb1dab5febe758a2049b5eadb83651c73e895d5f1765d0f560b49d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4299baf35494427dbc1b564c431a09f593da05b2be0d784b1233e5149e82c9d8"
    sha256 cellar: :any,                 arm64_linux:   "9ae29ffb6d9130b317f63337a4bc63bc5e9181e864e547b9b8fe6f298fa258fc"
    sha256 cellar: :any,                 x86_64_linux:  "defafcda4cc5e9ad1037cb0156f92d0b973153ab70d6f843905a729100b4bfbd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    (buildpath/".cargo/config.toml").delete if OS.linux?
    system "cargo", "install", *std_cargo_args(path: "crates/unifly")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unifly --version 2>&1")
  end
end
