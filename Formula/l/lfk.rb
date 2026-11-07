class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.16.tar.gz"
  sha256 "a80cefa3865a5490436ab736d3bae530ce676792a1517b6a202983b5e5f037f5"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "267a6b44f5dd13c307c9585d5b4ec17abe25ae22a6ca198d4c30b7251237a9f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "267a6b44f5dd13c307c9585d5b4ec17abe25ae22a6ca198d4c30b7251237a9f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164a27586663aa4d75f1cadd662c70820e8c800e3b32b1e6f4b301f5ce990068"
    sha256 cellar: :any,                 x86_64_linux:  "234ba7605f602efc0bd992a2eb3d2d0e31d44e5b4a1da7f4f4458cbd305cf9c0"
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
