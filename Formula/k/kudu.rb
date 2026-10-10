class Kudu < Formula
  desc "Manage QEMU virtual machines in the terminal"
  homepage "https://github.com/pythops/kudu"
  url "https://github.com/pythops/kudu/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "fb17469c2a8e627caeb301ca4ffb3c22e864b03b1df136f173d7f1cb317c10dc"
  license "GPL-3.0-or-later"
  head "https://github.com/pythops/kudu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "5e55ad094bc7dec276bf3d28529c85599f72c948fe5a2bf66d99b70fe73ec319"
    sha256 cellar: :any, x86_64_linux: "6e3252400972dc17bf01c8f13795bde7714cbe9f1bb50a23f86ee2ef2e410e94"
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
