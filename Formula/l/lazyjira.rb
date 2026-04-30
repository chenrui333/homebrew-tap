class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "bdb182d61c398d920938a96460fafd2879b08daf01f49f9abbd9f0ae4bf5cd7f"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2ee7ea1f04578e532005bec0f77d8282c686408a058d002c7078c923cd1545f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2ee7ea1f04578e532005bec0f77d8282c686408a058d002c7078c923cd1545f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2ee7ea1f04578e532005bec0f77d8282c686408a058d002c7078c923cd1545f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e5fb50f80e349af980ceeaaa620121439015a6ef384792023ee541d55cedaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6a405893ff630609abc02f58c7447bd7ac84d22260176cacc767dea1706a8e6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
