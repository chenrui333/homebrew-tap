class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.15.tar.gz"
  sha256 "d61263f664c23c552f857c776a4631d15208299d583bcced162f61ab0e28064f"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "166576d05cd53f49fdf961f66abdddeca62551f4208fb93ae4d3e6243812400a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "166576d05cd53f49fdf961f66abdddeca62551f4208fb93ae4d3e6243812400a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "166576d05cd53f49fdf961f66abdddeca62551f4208fb93ae4d3e6243812400a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b90fa9f1ea9ffe1e7b57166511ea662fd0f6adce97e2e0b46708e369a79086f0"
    sha256 cellar: :any,                 x86_64_linux:  "ac52a47e60e8f6704286ec6a7625d6d128bd5645f240ffefb0e1e21995b3ce2b"
  end

  depends_on "go" => :build

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
