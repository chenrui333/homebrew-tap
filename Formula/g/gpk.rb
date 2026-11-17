class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "2571f6005046d77dee9d5f0f4d2e5981887988d43c3cf6c8d1da5e8aa7d91c48"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36024bc2367399e26b776e32489529505f69316557088daa84f42befba0e1d75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36024bc2367399e26b776e32489529505f69316557088daa84f42befba0e1d75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87ae2d50e84e2abc3a23cc3693bd364f81f635ce5e618b4db9a076f0cde036d7"
    sha256 cellar: :any,                 x86_64_linux:  "a93fba1f9522d591ebf3dc37cee11a40c30d140eabd256f0ad2a280057014b07"
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
