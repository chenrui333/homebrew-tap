class Amdtop < Formula
  desc "Monitor AMD GPUs, CPUs and NPUs"
  homepage "https://github.com/lhl/amdtop"
  url "https://github.com/lhl/amdtop/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "fda067b61130fdcf01370cd311dec8a4020fc31459de20dede41302e118362db"
  license "Apache-2.0"
  head "https://github.com/lhl/amdtop.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkgconf" => :build
  depends_on "libdrm"
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/amdtop --version")
    output = shell_output("#{bin}/amdtop --invalid-option 2>&1", 1)
    assert_match "unknown option: --invalid-option", output
  end
end
