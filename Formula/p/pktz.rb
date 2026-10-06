class Pktz < Formula
  desc "Network traffic monitor with per-process visibility using eBPF"
  homepage "https://github.com/immanuwell/pktz"
  url "https://github.com/immanuwell/pktz/archive/refs/tags/0.3.0.tar.gz"
  sha256 "0d99adc43908863716cc67726140b40de856685399ae71c403ee0f5ba4f655b2"
  license "MIT"
  head "https://github.com/immanuwell/pktz.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "c37ac6c5230b41b7a92c18ac44258f61446f390f02e31228170c98e6872822bf"
    sha256 cellar: :any,                 x86_64_linux: "6d649170a0868376b20bb60c4b88fdb9686ba88446f240b61e019087ce700963"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "pktz", shell_output("#{bin}/pktz --version")

    output = shell_output("#{bin}/pktz 2>&1", 1)
    assert_match "insufficient privileges", output
  end
end
