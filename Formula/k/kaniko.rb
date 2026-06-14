class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.15.tar.gz"
  sha256 "4e5edbe0016f8de22b95734862dbcd807a81951723e5f7cf54055600fddc8955"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d4b5170b15cdc813fb96a161536f0c5fc18ce67baa6dc0eca1471ea4b95dae54"
    sha256 cellar: :any,                 x86_64_linux: "3d99723856f39b7c8d565bb900810dfa407232aeb1bd095780cc4e0beb7e389d"
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
