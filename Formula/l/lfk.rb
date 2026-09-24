class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.15.tar.gz"
  sha256 "3172412630e1d25ce0433bfcf9dbc9c434875722354d0a18bd903f96b4e59003"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e2bde70bb73ebf3db21e4282ae1e75b1a9bafab53b9269dc96f63278787c257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e2bde70bb73ebf3db21e4282ae1e75b1a9bafab53b9269dc96f63278787c257"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae18a6054e9e86df031bcc96b8cad9cc74754a48ee5a5a24d861ab1eac9c833"
    sha256 cellar: :any,                 x86_64_linux:  "c2f806d20169c6174eaa3436a1d6fa090625d6a8c73ab8aa438c9a322d5d4efc"
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
