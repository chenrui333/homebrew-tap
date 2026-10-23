class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v0.3.21.tar.gz"
  sha256 "3915f9439af2a0a22299a456e101295f7e924426cf4472f2de9cc0055980a863"
  license "Apache-2.0"
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  # v1.0.3 is a retraction-only tag for Go module versions, not a release
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70050744ecb7acdee2a538f922f870c4808f35eac0aa54bf8dda95b2d072490f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70050744ecb7acdee2a538f922f870c4808f35eac0aa54bf8dda95b2d072490f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2e245abc5767c0465415c846da8bb1ee7f9b29858d09af7a0c52a0ba149552"
    sha256 cellar: :any,                 x86_64_linux:  "a44a0538695b12f7b6ac682d57ca69506f79a2b61e3c113b081ebe02cb8b49ef"
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
