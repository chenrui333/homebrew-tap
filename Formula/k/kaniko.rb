class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.19.tar.gz"
  sha256 "669b5262e7bed331afdc39c4d0b99df11cb3df2c8c008ffc8e3c90f819ffbb1c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_linux:  "3062c1f6c4a02630ba9e36b73fe4f42d2afa7e5d6b0545b7da988189d6bd3385"
    sha256 cellar: :any,                 x86_64_linux: "75108ac7899f04ef04e59a484bf37bb025a57619da5fec8b9fcf93b08e32258d"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

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
