class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "9c5cf834d022e14d9ee35df953aeb58ae0480f1dc456a6616c1280c01ee16392"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "148084ba4dd0028879f1db44106e3cd9a9be8b26d1ad93053af33092f15a9085"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "148084ba4dd0028879f1db44106e3cd9a9be8b26d1ad93053af33092f15a9085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148084ba4dd0028879f1db44106e3cd9a9be8b26d1ad93053af33092f15a9085"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db2c711add789cb9accfde1fda85fe94e437ae7b314d6037eb713963e1384cf9"
    sha256 cellar: :any,                 x86_64_linux:  "106958e34abaa911c2571444ef345f25859236968649b58c0297e333c8fde9ed"
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
