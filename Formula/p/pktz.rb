class Pktz < Formula
  desc "Network traffic monitor with per-process visibility using eBPF"
  homepage "https://github.com/immanuwell/pktz"
  url "https://github.com/immanuwell/pktz/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0d99adc43908863716cc67726140b40de856685399ae71c403ee0f5ba4f655b2"
  license "MIT"
  head "https://github.com/immanuwell/pktz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c146a2d17563bdb519825848c67e1037bcee31a90ed6f499ef3bd0b0c4e2cb26"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "96366f2820617f393a52a261c1222319061c785fcc727d09b1dfb303e97aa77e"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "pktz", shell_output("#{bin}/pktz --version")

    output = shell_output("#{bin}/pktz 2>&1", 1)
    assert_match "insufficient privileges", output
  end
end
