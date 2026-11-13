class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "b141ede0499a7ec41c21782d41ebc08a87a95074e9c8c8efc7007d2ebf5e8f9e"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f36cd496f1c8d49f3c9fc9fc2514e2acfa377bfd847baf855b066c111927893f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f36cd496f1c8d49f3c9fc9fc2514e2acfa377bfd847baf855b066c111927893f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2e8ed4bf5521887ad814ecbf135c63b0ffb47484259ad139bfb738a6c79501"
    sha256 cellar: :any,                 x86_64_linux:  "438e492210e18baf5301a2dc19462f26c7d5a6ba19ae00a60fbc639c686ce558"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/lazymake --not-a-real-option 2>&1", 1)
    assert_match "unknown flag: --not-a-real-option", output
  end
end
