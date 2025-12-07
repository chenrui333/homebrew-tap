class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.9.4.tar.gz"
  sha256 "5138ddf35c3c0dce2af25a6a69368a1101e9dc71aede60dcb6b96ff771d32f9f"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5902c30f0b914cce25674b72101be6745b3f92a79f3fa7793236cf84d34f145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5902c30f0b914cce25674b72101be6745b3f92a79f3fa7793236cf84d34f145"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5902c30f0b914cce25674b72101be6745b3f92a79f3fa7793236cf84d34f145"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541a22a8e336296f3e169ec1f9980bf0b8f7017b324817e8bd5caaa9df7639e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66e8696c15cb1e447f0422b9e6c8ccad1cf20530887dab7c3ee9e1646969219b"
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
