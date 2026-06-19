class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "0f30ee12e90cc180c575308f2b4aa3c5e110405da52882a9c390c2699f242383"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aedded007e2488a2542b80392cee64a1926b11de742d2d344a8ae7fdbbc45fe9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aedded007e2488a2542b80392cee64a1926b11de742d2d344a8ae7fdbbc45fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aedded007e2488a2542b80392cee64a1926b11de742d2d344a8ae7fdbbc45fe9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc7d4a223a8565e7e30f463866642ee0c2d30fdf25b93e9f9f37a653c9def798"
    sha256 cellar: :any,                 x86_64_linux:  "6f902c85c2fa046dc36f6a11074b105e3ab5eca8344291fae3c3bda93560495f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
