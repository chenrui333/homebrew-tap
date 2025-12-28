class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.9.4.tar.gz"
  sha256 "5138ddf35c3c0dce2af25a6a69368a1101e9dc71aede60dcb6b96ff771d32f9f"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "262052a10e0d390245cce896634ff3fdf3c1fa2fc4f317887f3a1a0a0f6283b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "262052a10e0d390245cce896634ff3fdf3c1fa2fc4f317887f3a1a0a0f6283b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "262052a10e0d390245cce896634ff3fdf3c1fa2fc4f317887f3a1a0a0f6283b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27663aa15d4d1b46fdacf83e4ac8d6116cc548052e3202e54d96e43649162aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446e497618a4d9a6529061589b9d9a8102ce31348e5ea68a400a76b6903b840e"
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
