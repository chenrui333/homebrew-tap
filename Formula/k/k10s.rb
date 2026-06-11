class K10s < Formula
  desc "GPU-aware Kubernetes TUI"
  homepage "https://github.com/shvbsle/k10s"
  url "https://github.com/shvbsle/k10s/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "80af292b682d12ecc81eb92638520000d17f1d3ec24244adc26f3809c0bf62b0"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7c90dcca3fdb4124340de432633b8129021603626bdc6ef4400d07cc01b0b61"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bb358a356a326ac135f98e09f27b0bd77b692cdcfb7eec3691d09c4b326cb22"
    sha256 cellar: :any,                 x86_64_linux:  "8a3d55c7264afc2df37a731825c0e46161d71ed4160dff0be7acacfa4a6939da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/k10s"
  end

  test do
    output = shell_output("#{bin}/k10s --help 2>&1")
    assert_match "k10s", output
    assert_match "log-level", output
  end
end
