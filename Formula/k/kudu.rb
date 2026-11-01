class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "447f2e68c7ed6949e7564625570afed73f15fa2b70139e7543432c20b7a03dcf"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "8731811ad17a0983db65a5d22b7388493a0a7b9bfca1aa633aeb4d6304b8da87"
    sha256 cellar: :any, x86_64_linux: "74ef32f4ab735b588d839dfb43761c60af23a64497690e9cd7990a6e054df894"
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
