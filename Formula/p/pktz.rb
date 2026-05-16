class Pktz < Formula
  desc "Network traffic monitor with per-process visibility using eBPF"
  homepage "https://github.com/immanuwell/pktz"
  url "https://github.com/immanuwell/pktz/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0d99adc43908863716cc67726140b40de856685399ae71c403ee0f5ba4f655b2"
  license "MIT"
  head "https://github.com/immanuwell/pktz.git", branch: "main"

  depends_on "go" => :build
  depends_on :linux

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "pktz", shell_output("#{bin}/pktz --version")

    output = shell_output("#{bin}/pktz 2>&1", 1)
    assert_match "permission", output.downcase
  end
end
