class Lazymake < Formula
  desc "Terminal UI for browsing and running Makefile targets"
  homepage "https://lazymake.vercel.app/"
  url "https://github.com/rshelekhov/lazymake/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "49dc29635990385fef22717d23c986a62803dc2afeeb428e0a1910711b169c37"
  license "MIT"
  head "https://github.com/rshelekhov/lazymake.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "717335175dde6bd8c6d9298d1af539e3b09a2a7122a689d0c0a3eba9f95d5c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "717335175dde6bd8c6d9298d1af539e3b09a2a7122a689d0c0a3eba9f95d5c3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "717335175dde6bd8c6d9298d1af539e3b09a2a7122a689d0c0a3eba9f95d5c3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "614b2c469403ea787266ced7264af8dd0b41b116141abe870ddb55e367ed7ff7"
    sha256 cellar: :any,                 x86_64_linux:  "24a91a9703d621eb602f67682a7908eacf5ae6a6f721149003c6b053ea203fa6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X github.com/rshelekhov/lazymake/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazymake"
    generate_completions_from_executable(bin/"lazymake", "completion", shell_parameter_format: :cobra)
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/lazymake --not-a-real-option 2>&1", 1)
    assert_match "unknown flag: --not-a-real-option", output
  end
end
