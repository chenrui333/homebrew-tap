class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "50c585c14f6ec8c039a3c458af424af77c236ee55aeef6dfb37a63cac7ece6cb"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e0d39e9c0728c7eeb56fb08f4f2aeabcf368d2373274b68ae4cb2c3e27c7dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e0d39e9c0728c7eeb56fb08f4f2aeabcf368d2373274b68ae4cb2c3e27c7dd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e0d39e9c0728c7eeb56fb08f4f2aeabcf368d2373274b68ae4cb2c3e27c7dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "629253ab270fb2e5b77ad61128c463e529d7644d184473b1a9ac5754e0d76cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41dbbe3831115bfe3469b62d51adc552113a7688c8e8929ab936f13204367448"
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
