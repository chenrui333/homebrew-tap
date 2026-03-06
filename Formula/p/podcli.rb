class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.11.0.tar.gz"
  sha256 "5d52d1abec9ac07480d958d3c3f2bd43591238577f0a38e1de43d18539b5f1f0"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d55f24b22805e1b4654bd6d85bdf34e86171fcba329db7ead0ea3e7a8bbf4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37d55f24b22805e1b4654bd6d85bdf34e86171fcba329db7ead0ea3e7a8bbf4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37d55f24b22805e1b4654bd6d85bdf34e86171fcba329db7ead0ea3e7a8bbf4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885bd402b47b174fc3e90b00d94d58165441fae74f0cd76c928a632cb88c22fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1c1990a696433e2c5450c782a0a0a82c68bf1704b367e72366cae0ae63af38d"
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
