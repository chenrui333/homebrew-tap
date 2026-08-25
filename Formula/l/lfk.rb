class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "fb443b03158ae39ac0b7d14b98d4d839ba38114d7bdfdce199d0bd8522046e48"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "749a46f32f0565c29eff0994154f2872848c3f71f44a47fbbcb98125e99cdb42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "749a46f32f0565c29eff0994154f2872848c3f71f44a47fbbcb98125e99cdb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "749a46f32f0565c29eff0994154f2872848c3f71f44a47fbbcb98125e99cdb42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251ac7a9846b1a2342b31bc1ba52f3023fcb1b2bc8094c4f9eeaf9556364ea76"
    sha256 cellar: :any,                 x86_64_linux:  "6010c05fdbc57323b144a32d79845cc5ed519c28311d7a6bc6388a105fed103e"
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
