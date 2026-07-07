class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a12606b3f8f1b793b65de1f47b1a606406a06c17ff1d1647f9b38708909204d2"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa7c94ac124569c099811e1445a9c9931654c0f0ebaedab8c08dab46a9ee7c1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa7c94ac124569c099811e1445a9c9931654c0f0ebaedab8c08dab46a9ee7c1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa7c94ac124569c099811e1445a9c9931654c0f0ebaedab8c08dab46a9ee7c1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e24cf667322608573e114e46f91056e430f88d7adaae8a3ea9d03d412b8577b"
    sha256 cellar: :any,                 x86_64_linux:  "568b4e989fe8e19f6ff982dea55e60c71c9c3b95af4038df6f65a20253e2fcc8"
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
