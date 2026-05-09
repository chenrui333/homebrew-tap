class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "16194f20ef6d7411affdd54b0b094217b4c0945b4ac36a6a3081f80efed3cd74"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee7569a914737ed47e095ce682f71052b92c4cfda98bcd5b31751606060351c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee7569a914737ed47e095ce682f71052b92c4cfda98bcd5b31751606060351c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee7569a914737ed47e095ce682f71052b92c4cfda98bcd5b31751606060351c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2ad15d37f29781dae01973d9f93d260f8040ce7292e756f8bbb6d67f234d0b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2930e47cfe529b5425401ae2e4ff7d0242aa42c853e6a536bde8e070dc2433fa"
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
