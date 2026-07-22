class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.14.1.tar.gz"
  sha256 "d641b2b2d78f24d48f1eaaf200ea869b710edf6718b90baeaf42b2f345b50ae8"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cc1dc2f85b3ec4fa70e622b4bb59ef785a43273616856c5e287b209a8fed368e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc1dc2f85b3ec4fa70e622b4bb59ef785a43273616856c5e287b209a8fed368e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc1dc2f85b3ec4fa70e622b4bb59ef785a43273616856c5e287b209a8fed368e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f6ef901f101f7f247f3da769f82229d8157c745f206a8fecdf9810bd73559c6"
    sha256 cellar: :any,                 x86_64_linux:  "dda8796baa6846be2c1adaabf1efe0155cf809f164364ffc2307f408862fdd36"
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
