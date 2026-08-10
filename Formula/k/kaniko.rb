class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.18.tar.gz"
  sha256 "94d925a73b1da11c46a6feafb6870d05dcbffb5d014d111b149f3fb51722c037"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "6789c6dd28add36c051490090f6bb684349dbd09287ba953eb121d1b7fa1f294"
    sha256 cellar: :any,                 x86_64_linux: "4d4cace3ec73c7b81c7f49241cc3c1360e53185f0f8c7fff097708c29a3dc623"
  end

  depends_on "go" => :build
  depends_on :linux

  def install
    ldflags = "-s -w -X github.com/chainguard-dev/kaniko/pkg/version.version=#{version}"

    %w[executor warmer].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/"kaniko-#{cmd}"), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaniko-executor version")
  end
end
