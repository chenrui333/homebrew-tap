class Unifly < Formula
  desc "CLI/TUI for UniFi network controller management"
  homepage "https://github.com/hyperb1iss/unifly"
  url "https://github.com/hyperb1iss/unifly/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "191bd6e24d1c5ae79d4b6deb4f4d705d0516d01a44f5287e2103168711c08fe6"
  license "Apache-2.0"
  head "https://github.com/hyperb1iss/unifly.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f55f9f571c8bc2b1bcb31a02c6684ccf18344502e89be7ff94b2a82571b373e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c74c03a460827cb1fb737ec9d6f8ab3ba11dd1d4c314d03b209b6a6d94a69a57"
    sha256 cellar: :any,                 arm64_linux:   "3de30823311cf36b1151aa6e1581285259f9b2036ec931acb959ea0780b55e97"
    sha256 cellar: :any,                 x86_64_linux:  "db85666d8acbaf1a654010e4a794a63ab489312b766f86560f541622cb2546d7"
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
