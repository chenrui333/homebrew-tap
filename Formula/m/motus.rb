class Motus < Formula
  desc "Dead simple password generator"
  homepage "https://github.com/oleiade/motus"
  url "https://github.com/oleiade/motus/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ac46d6e152293edf6aa30aaf40fcb8250429127f1ce8c59da3022dcedaa94633"
  license "AGPL-3.0-only"
  head "https://github.com/oleiade/motus.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bde322c79b77cfeec2f8f86098d5b9e63cbac1d15da62a39af85ed7b8d71f270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5abb9c7f774f05202050d685f332a184e28ea74dc97291237c79aaceee6a61f2"
    sha256 cellar: :any,                 arm64_linux:   "2a3bbd7413587a4c88060350a0b05da9375c8f9efaa9ca603f9ae559168cc351"
    sha256 cellar: :any,                 x86_64_linux:  "6f2dd5b492cc205ac6c270e31f80e7020732979ccf6a922622e68363bfc9828c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The clipboard feature pulls in GUI-specific X11 clipboard support on Linux.
    system "cargo", "install", *std_cargo_args(path: "crates/motus-cli"), "--no-default-features"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/motus --version")

    output = shell_output("#{bin}/motus random -c 2 2>&1", 2)
    assert_match "The number of characters must be between 8 and 100", output
  end
end
