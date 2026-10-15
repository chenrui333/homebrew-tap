class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "f142146acad1e840ed93cde738aaa054b7ec4f43e1b0ff6a8ab01fb43757cdf1"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85b594d9acd71ff84a1c5a8788f3b19ca2e4fe8d4ad121af949620561a3d16c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85b594d9acd71ff84a1c5a8788f3b19ca2e4fe8d4ad121af949620561a3d16c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0762650fda06ef78e4d2d89c5e8834963fe85f651d9488cf12e56bed819b3fb"
    sha256 cellar: :any,                 x86_64_linux:  "087472dd9a8c91833940930ce8e39e2e0fd320088e27d00df1363ba898a27d67"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
