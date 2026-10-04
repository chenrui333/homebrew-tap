class Kmon < Formula
  desc "Linux kernel manager and activity monitor"
  homepage "https://kmon.cli.rs/"
  url "https://github.com/orhun/kmon/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "fd8e02c17089e88c2b019e116e0b7fdd9fe4285327bd795de90622aba4b79469"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "3e116256290d9815fbc17a33516d11f452201c8b10d71d79ecd1dc119c7cbdfc"
    sha256 cellar: :any, x86_64_linux: "6fc3265a0780dc4825a3b57114b1ef31c406803550d82e39fe7443918985d981"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kmon --version")
    assert_match "unexpected argument", shell_output("#{bin}/kmon --invalid-option 2>&1", 2)
  end
end
