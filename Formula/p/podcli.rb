class Podcli < Formula
  desc "CLI for podinfo"
  homepage "https://github.com/stefanprodan/podinfo"
  url "https://github.com/stefanprodan/podinfo/archive/refs/tags/6.9.4.tar.gz"
  sha256 "5138ddf35c3c0dce2af25a6a69368a1101e9dc71aede60dcb6b96ff771d32f9f"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/podinfo.git", branch: "dev"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f39971387c5b1c20949cab58ad389ad484e7fb19096b294fb59be988510be106"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f39971387c5b1c20949cab58ad389ad484e7fb19096b294fb59be988510be106"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f39971387c5b1c20949cab58ad389ad484e7fb19096b294fb59be988510be106"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e61ec67bfa7f7638e5f544c1cccc41ae4226f571ea06b7ce3b6116da99571eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3326f01cb5884e227b1bec7bd2e706aa21f1177cc042270a548a5f8bad922cc2"
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
