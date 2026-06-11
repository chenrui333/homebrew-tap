class K10s < Formula
  desc "GPU-aware Kubernetes TUI"
  homepage "https://github.com/shvbsle/k10s"
  url "https://github.com/shvbsle/k10s/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "80af292b682d12ecc81eb92638520000d17f1d3ec24244adc26f3809c0bf62b0"
  license "Apache-2.0"

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
