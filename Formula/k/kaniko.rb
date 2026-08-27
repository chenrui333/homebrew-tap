class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.19.tar.gz"
  sha256 "669b5262e7bed331afdc39c4d0b99df11cb3df2c8c008ffc8e3c90f819ffbb1c"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d4fe56290211f026b62a5c096a6f5b1574ffe98f3797656c2f05afc8c972ddf2"
    sha256 cellar: :any,                 x86_64_linux: "5fcf7d5bc3e916cfa41e815eed6f162fac3f1b041c8a686bf4d711f0639bbbe6"
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
