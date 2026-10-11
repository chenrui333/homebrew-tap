class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "fb17469c2a8e627caeb301ca4ffb3c22e864b03b1df136f173d7f1cb317c10dc"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "916dcb7592bc3606bf97c37cae17e5979e398e39a4f46d31a1470d632ba5bb48"
    sha256 cellar: :any, x86_64_linux: "30df9fbf5d02c08f671fb3e80beb2050acdd2d142da66d562f41b55c8736cf48"
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
