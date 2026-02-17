class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.3.tar.gz"
  sha256 "90ce11eb500158b266a83af78af351254e5d67cdca7980d34f4744134ff5328e"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/chainguard-dev/kaniko/pkg/version.Version=#{version}"

    %w[executor warmer].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/"kaniko-#{cmd}"), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaniko-executor --version")
  end
end
