class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.10.1.tar.gz"
  sha256 "ee776114dbc0e1c8878c7dee5bd60baabe8e77c156e5a0ab6a931ecedebf266e"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50a98552d936d1c561891a1a83925b7ceb65f36362d39f1e3a4b9aa38a3235e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50a98552d936d1c561891a1a83925b7ceb65f36362d39f1e3a4b9aa38a3235e2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50a98552d936d1c561891a1a83925b7ceb65f36362d39f1e3a4b9aa38a3235e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90467bcb71dab8503fc8a6d69aeccd557897646cc59dcaf88ef09b30f5044082"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79bdf87db3189b9859d23f25da85c6f6b14b2739f3a5ab4d5210f8de1e988e4b"
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
