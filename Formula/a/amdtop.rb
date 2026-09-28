class Amdtop < Formula
  desc "Monitor AMD GPUs, CPUs and NPUs"
  homepage "https://github.com/lhl/amdtop"
  url "https://github.com/lhl/amdtop/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "fda067b61130fdcf01370cd311dec8a4020fc31459de20dede41302e118362db"
  license "Apache-2.0"
  head "https://github.com/lhl/amdtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any, arm64_linux:  "d30e79ac6b9312552065c8b7410a5a3af9b9a90ac56c4b616d681ed4bb43c41f"
    sha256 cellar: :any, x86_64_linux: "5b69343805b7d816e1c56558618cf16d816dcf49190ebf7489c20531308612d3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libdrm"
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amdtop --version")
    output = shell_output("#{bin}/amdtop --invalid-option 2>&1", 1)
    assert_match "unknown option: --invalid-option", output
  end
end
