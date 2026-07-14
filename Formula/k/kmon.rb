class Kmon < Formula
  desc "Linux Kernel Manager and Activity Monitor 🐧💻"
  homepage "https://kmon.cli.rs/"
  url "https://github.com/orhun/kmon/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "fd8e02c17089e88c2b019e116e0b7fdd9fe4285327bd795de90622aba4b79469"
  license "GPL-3.0"

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"gerust", "--version"
  end
end
