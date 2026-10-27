class Kaniko < Formula
  desc "Build Container Images In Kubernetes"
  homepage "https://github.com/chainguard-dev/kaniko"
  url "https://github.com/chainguard-dev/kaniko/archive/refs/tags/v1.25.20.tar.gz"
  sha256 "bc2d14e3373059e0042f55abc689f126230256c78e0734e576339d7f0c4f7957"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/kaniko.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_linux:  "7f1d877ee66502269cc4a9a8d385d1349b794d8347b4052b757e12a75d7e212b"
    sha256 cellar: :any,                 x86_64_linux: "2eb6de062b2dd903fe8ffbaccb18456242d8cf5d1880bbfb9f286ba73ef748e5"
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
