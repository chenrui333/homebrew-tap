class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "db68bf35e824d24b97f01a4f1604f7b365e87c4dc4371bbeea7ddef4622b2d24"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7d2ccb2cf0ced513c38671db86271da7e380a90ab0099fd5db27f34b9abb06d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7d2ccb2cf0ced513c38671db86271da7e380a90ab0099fd5db27f34b9abb06d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7d2ccb2cf0ced513c38671db86271da7e380a90ab0099fd5db27f34b9abb06d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdde026a438c9428062bdf78345aa4ab1e78671f616b53223e7dd98ed48cf1e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b252f21a2cfd068ec7b219f1e9cc967e140fbe20c0fe16f2780d06b57b63008"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
