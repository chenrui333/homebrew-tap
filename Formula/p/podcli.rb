class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.11.2.tar.gz"
  sha256 "a7ff15d25d1e758ed0db695371df93eb578166af1bf32af9546ce78ac1ca605d"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a93363e41ffbb59225ed46ef16094f39025d7eb419d50cf9f45054431bbdad9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a93363e41ffbb59225ed46ef16094f39025d7eb419d50cf9f45054431bbdad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a93363e41ffbb59225ed46ef16094f39025d7eb419d50cf9f45054431bbdad9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef990b0d284a78b7371531cc4a559d87361bbd0867e06d2ce7f1b32e2b9601e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b50d6ff60b04acfcf253f701b062dca7c04cf6806ebda05893bf5d766c2570c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stefanprodan/podinfo/pkg/version.REVISION=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/podcli"

    generate_completions_from_executable(bin/"podcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/podcli version")

    output = shell_output("#{bin}/podcli check http https://httpbin.org 2>&1")
    assert_match "check succeed", output
  end
end
