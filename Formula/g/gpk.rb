class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "1f90b1192b4d145d725f7132b0b72f9f9bb75d9931aebd49162d5111c00299c8"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce53f1784bfd2e032621d2033adb31efdd89f69ae8f4044e835e29b2984742e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce53f1784bfd2e032621d2033adb31efdd89f69ae8f4044e835e29b2984742e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce53f1784bfd2e032621d2033adb31efdd89f69ae8f4044e835e29b2984742e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a0b10fbe6459b701fa064d663f2423e3febf395eec44b4090f9a9cd1bbf9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5862be8fcff4806d4eb4594f33e759dea407fdf1e18d2a2ff76a1b702363734"
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
