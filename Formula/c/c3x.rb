class C3x < Formula
  desc "Open source cloud cost estimation for Terraform, Terragrunt, and CloudFormation"
  homepage "https://github.com/c3xdev/c3x"
  url "https://github.com/c3xdev/c3x/archive/refs/tags/v0.3.19.tar.gz"
  sha256 "6d37b7b9b277ae4c1d98152316f76e1741e4362cd24f8b45a161cf7a2ca5295b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/c3xdev/c3x.git", branch: "main"

  # v1.0.3 is a retraction-only tag for Go module versions, not a release
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2b1efd26e6fb4fdbff57880b168340f3a8a25b63d8a8aafafb1a714fb888c22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2b1efd26e6fb4fdbff57880b168340f3a8a25b63d8a8aafafb1a714fb888c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3a320dd7c3a93a51561e6819421aa96ce9a9f632fe11f34cf4763afa7e5a583"
    sha256 cellar: :any,                 x86_64_linux:  "de3e16625416d4825d398e51cff49a08ba3fb0d53b43ff16cc2ba88c63832c4b"
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
