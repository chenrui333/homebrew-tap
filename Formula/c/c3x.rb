class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v0.3.20.tar.gz"
  sha256 "c007ccaafd3bfc5dd488d9ff5f5945a2389ed2fbe92dfd6e6be433db056a28d7"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  # v1.0.3 is a retraction-only tag for Go module versions, not a release
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27c8447fe4abb3ac5f38148a1ba6b51ea4d309a876cbb8eb4f96a6b4894e0ff5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27c8447fe4abb3ac5f38148a1ba6b51ea4d309a876cbb8eb4f96a6b4894e0ff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6f0e33faecc1652440081ef7ef230fe0eb54c9462d3db76d5664fb65486a66"
    sha256 cellar: :any,                 x86_64_linux:  "182216a3ea5250d49a5f5c5f82be6ba9379265e4fdceb47166bcde20e03d24ce"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/c3x"

    generate_completions_from_executable(bin/"c3x", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c3x --version")

    output = shell_output("#{bin}/c3x not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
