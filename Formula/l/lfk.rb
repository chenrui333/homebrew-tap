class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.11.tar.gz"
  sha256 "adfe19dbcaeac04683959ad531c13e526eeafc266824a2e4e62f8c7660a83e09"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3dff24529085b95abd9c361a8af20ac998ec105392e853c0a9361a89ac321528"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dff24529085b95abd9c361a8af20ac998ec105392e853c0a9361a89ac321528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d94c24e46392c11fb1aaa366107deb9caf6d8e4a424d3786de652ffa7cfe69fd"
    sha256 cellar: :any,                 x86_64_linux:  "04e3a280d43aa986b8ade26f076d399b5f730fe8f628ddf3555003948d504035"
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
