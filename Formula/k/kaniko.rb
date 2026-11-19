class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.24.tar.gz"
  sha256 "6ab71a06441d40bfdbc21a6bb482a6361c0e3bb7a6bec8828543bbfb15198bc3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "aafe3930d412cd850d0cb2221164901c2cf0da223b871ec099eebbb8c0b71854"
    sha256 cellar: :any,                 x86_64_linux: "2a55b971a77b69bdbf98781ad746a38c86e56c3bafa4a8d08c52e2c3c7472485"
  end

  depends_on "go" => :build
  depends_on :linux

  deny_network_access!

  def install
    ldflags = "-X github.com/chainguard-dev/kaniko/pkg/version.version=#{version}"

    %w[executor warmer].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/"kaniko-#{cmd}"), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaniko-executor version")
  end
end
