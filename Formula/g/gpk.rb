class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "42c6a369bd97a0e084ecb878dc52122f4610071c846cd3bd8209518f2c468a7e"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fd2c6218bd76faff0d8a3f5574de9340d78ff64fff2314bae57939bd4569ca7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fd2c6218bd76faff0d8a3f5574de9340d78ff64fff2314bae57939bd4569ca7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fd2c6218bd76faff0d8a3f5574de9340d78ff64fff2314bae57939bd4569ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6e557f14d7a6eb159a009517599cf9c129ca7ecf48f0cfeca7d1b0ecfc7ab8f"
    sha256 cellar: :any,                 x86_64_linux:  "83c4ccbf134a8914d40730fe14c1ed787dc9080a17a2e4ab35af52ddf715828f"
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
