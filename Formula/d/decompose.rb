class Decompose < Formula
  desc "Reverse-engineering tool for docker environments"
  homepage "https://github.com/s0rg/decompose"
  url "https://github.com/s0rg/decompose/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "802a1d155df0bea896483da4162ae555d7e1e1d5e293ec8201508914314eb36b"
  license "MIT"
  head "https://github.com/s0rg/decompose.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f56d06ba58b28b572b3c8fc83da86622229cf21d179b2230837f0bdaaa62817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06f2f1b05bc96781a44246bdca8137f1a948d316dc0af3bc463c2b4a64d913f8"
    sha256 cellar: :any_skip_relocation, ventura:       "6583b82f217fbf56ed8075bc8156d0b0ba43eb5fcba3c45016d695708ed4df8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "675074fa1e512bb4d926cb61fb288ada14d6770a8cb59cf32e3bc0e22b251898"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.GitTag=#{version} -X main.GitHash=#{tap.user} -X main.BuildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/decompose"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/decompose -version")

    assert_match "Building graph", shell_output("#{bin}/decompose -local 2>&1", 1)
  end
end
