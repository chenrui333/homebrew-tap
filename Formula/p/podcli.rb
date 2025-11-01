class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.9.2.tar.gz"
  sha256 "03c65174ed2bb0818b8a503d4e9d34408ff5d2775f77879b8cecdee6bf2a17c8"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17470b98ae072e203f462719e76f66df8a29d9c4e060b0dfa47d4321ee89df62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17470b98ae072e203f462719e76f66df8a29d9c4e060b0dfa47d4321ee89df62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17470b98ae072e203f462719e76f66df8a29d9c4e060b0dfa47d4321ee89df62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a79dcff09aa0af69988221e4a10e0a6afc7ea91bfa0b20a34c46d8b426eff2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3227c131129cd7c982f76453b0fdfc8b4f16a4c982d7419710456e83fde9e363"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/stefanprodan/podinfo/pkg/version.REVISION=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/podcli"

    generate_completions_from_executable(bin/"podcli", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/podcli version")

    output = shell_output("#{bin}/podcli check http https://httpbin.org 2>&1")
    assert_match "check succeed", output
  end
end
