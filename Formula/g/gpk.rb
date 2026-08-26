class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "42c6a369bd97a0e084ecb878dc52122f4610071c846cd3bd8209518f2c468a7e"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a06b0abc4339d2cb23512bdc324501e61a87568bc3e18a73b58aef236b8e75b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a06b0abc4339d2cb23512bdc324501e61a87568bc3e18a73b58aef236b8e75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a06b0abc4339d2cb23512bdc324501e61a87568bc3e18a73b58aef236b8e75b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0269be4b98770229ecbfafe5c655dee8f77e38ed6e32b9bc448f3862efccd416"
    sha256 cellar: :any,                 x86_64_linux:  "1f802c5a8938a436bfe51b4692b6967a834483f1b1d8fc5944626c57b071de40"
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
