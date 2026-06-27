class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "95a4127143a86dfd4fe40d467f97efb70f04e9fa5012fe737887a93b8c37e2b2"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc4d75c18ceb7f82e0be70fb77af073e5f750bbf92e545db49edce2ed9dee354"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc4d75c18ceb7f82e0be70fb77af073e5f750bbf92e545db49edce2ed9dee354"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc4d75c18ceb7f82e0be70fb77af073e5f750bbf92e545db49edce2ed9dee354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "993b293a2507459da93ea1ec61a9b51d70aa2bf9797b3c6f2858dd2cf64ac459"
    sha256 cellar: :any,                 x86_64_linux:  "df8c8d7a0af83207fa9cec927c94d713d5a9960bb9ffaed217064b4095cab9e1"
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
