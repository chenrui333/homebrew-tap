class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.10.2.tar.gz"
  sha256 "61d80d3057ecaa7abf8286dfdf7035a5d0c45584e74a2f312942d0bfd3318d93"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80beb82bae8021e6171d613299e7592a6aafa81888b49629ddace22f24588264"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80beb82bae8021e6171d613299e7592a6aafa81888b49629ddace22f24588264"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80beb82bae8021e6171d613299e7592a6aafa81888b49629ddace22f24588264"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d53bd9de0978964e4aa9c967fb9ed9fb518f50a2bd8ca2fe08d7ddca4b14090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34e4c7ef1b01dd0edc3d25c668b1632bbc12742dd1d8799787bd264255cf9496"
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
