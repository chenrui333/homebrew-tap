class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "04d4e8684a7a66496a559047fb7dc64e097b497b84df9acdd0eefd5aee1ffef9"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd7d4ca3e95cd5a269f4ed125c1a044528e72b45a8982ee7e6e97bb3d8cbd8fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7d4ca3e95cd5a269f4ed125c1a044528e72b45a8982ee7e6e97bb3d8cbd8fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "31d7189d11e8f5ab314578edfe684d2bd0f302f6d1a06efad6d172107e4e952e"
    sha256 cellar: :any,                 x86_64_linux:  "d9ce95233ec4b3189b6107b0379e20d49bbe327147c68ac5e2e1b6887529f202"
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
