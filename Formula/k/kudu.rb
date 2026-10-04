class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "7290a1368e8ff01e90b68aaf57233bf5c6c949f3b017b7d51f30f6dd8dab749e"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "68886bce9b0d60bf0bc092ebaea00dfff94877f5f0b196d221d8c5303a38912f"
    sha256 cellar: :any, x86_64_linux: "b05cf0ba5b825252ac596cc44c570730a954778a9aad68aeb72350412d1f0d0e"
  end

  depends_on "rust" => :build
  depends_on :linux
  depends_on "qemu"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kudu --version")
    output = shell_output("#{bin}/kudu --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
