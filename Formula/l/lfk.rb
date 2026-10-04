class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "a129b6b7b81382a6983e1cc05e704925cbe8bc763bffa014dc61022ac38a65ea"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45d25a166d3be4287d71f2f9a5077776b5d8fab6f283b79d4ad2d9ba2f3e25c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d25a166d3be4287d71f2f9a5077776b5d8fab6f283b79d4ad2d9ba2f3e25c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde4d2bf75956567862d36ef8edf99dbc17c1765e24162ddf764e36c3eb80af6"
    sha256 cellar: :any,                 x86_64_linux:  "7f7cf8ff18ce945f95e90bdec4a0d39da9cdff698d8e63d2234721594be18cb1"
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
