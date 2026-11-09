class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.22.tar.gz"
  sha256 "6c0a8429c3b678a1057109763d5a327c5763ade027a10d0cca60925bb191e3d3"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7e7006dfca6003690941cfa77e692016f8249bc19eac067a463db1ac9b64e1b4"
    sha256 cellar: :any,                 x86_64_linux: "6dc0d7df2649e22338d9a5f4ff07974c0c6179edbee25b3e9b3775e74a527644"
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
