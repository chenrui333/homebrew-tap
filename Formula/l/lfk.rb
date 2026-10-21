class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "b671a5b374bbe01533931b4f4d6f4f5f50c53d6fc15f4c7a9e0d8b174b9983a8"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c7562ed797c02b7ae8eb194d46209d133f8d2959bde0687c026baecaf1aec40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c7562ed797c02b7ae8eb194d46209d133f8d2959bde0687c026baecaf1aec40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4e0feac08ae55db3128fde3a9351872d0109652d4e7de2f94ce9fd509a29ce"
    sha256 cellar: :any,                 x86_64_linux:  "4f60fc67c37543d39a9560d16e8766f22f4cf60fd7fba5e2afdd683ac35e406f"
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
