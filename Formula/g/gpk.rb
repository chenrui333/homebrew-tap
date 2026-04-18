class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "510f8f2062f89f9a6dc3dbf6055291f3f04d7707a8214115ca10db20d15bded9"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12000826aa33345eb248a8448f89b3d02babd5b3a816d0ec5988f89d4f676d21"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12000826aa33345eb248a8448f89b3d02babd5b3a816d0ec5988f89d4f676d21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12000826aa33345eb248a8448f89b3d02babd5b3a816d0ec5988f89d4f676d21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a7d726c08b4d111d1e44c532a827b99d069f32a637e233836b5695f151d421d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587fa913ae40a38f2ac60b2a4cffb0e1619f3e29884b54b72b91d8a9e3d61590"
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
