class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2571f6005046d77dee9d5f0f4d2e5981887988d43c3cf6c8d1da5e8aa7d91c48"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b228f4610fbb72e4c733c01680544cca8c7717aaf87dcbd288f0fd79552d1a4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b228f4610fbb72e4c733c01680544cca8c7717aaf87dcbd288f0fd79552d1a4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7e2f46a44f9df7ec30d3051e263e584115da3fcbc267d5cff7e0e0e4d1f8a5a"
    sha256 cellar: :any,                 x86_64_linux:  "3f11b98dcf13168c3e3d40a119253e6d399cb7dcbee9ee17f69463162a782609"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
