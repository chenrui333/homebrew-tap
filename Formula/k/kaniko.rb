class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "38daea316bc6967cbabd6a8571718b3958e84c464a57895562992297468e0a92"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/chainguard-dev/kaniko/pkg/version.Version=#{version}"

    %w[executor warmer].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/"kaniko-#{cmd}"), "./cmd/#{cmd}"
    end
  end
end
