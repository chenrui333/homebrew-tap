class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "1ef135164e1bc9c04fa78f02a898ba0bec63e3fb3aa98f4e7a35dc98cc435b18"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a19861a3ab59f8525ae04b667ebb4a645a9674529313066c3199b8bcbc1427bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a19861a3ab59f8525ae04b667ebb4a645a9674529313066c3199b8bcbc1427bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a19861a3ab59f8525ae04b667ebb4a645a9674529313066c3199b8bcbc1427bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36dbc33727e7f7747ad5a51b46ec612ad579be4001d0f4965f04436f6cbafaff"
    sha256 cellar: :any,                 x86_64_linux:  "e000a45ab3c80e34b3bae77f66fd478c18124224e6bcba925a1e50ab840a10a3"
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
