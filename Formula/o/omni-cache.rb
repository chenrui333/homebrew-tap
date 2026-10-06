class OmniCache < Formula
  desc "Sidecar for your caching needs in CI"
  homepage "https://github.com/cirruslabs/omni-cache"
  url "https://github.com/cirruslabs/omni-cache/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "adb2b16e27a632f71a69b3c8aec03ce175f796a9daf79c2e1b0ae278c4f8b767"
  license "Apache-2.0"
  head "https://github.com/cirruslabs/omni-cache.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9716d101d3720a2d2d7c4b3eebef81caae3bee940afce3962a5d83941bd68258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "224380e6136fdc0efb4f2165c6fc6c3e66c3d4531db544c81b7ffbf0c59a1868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76d77e4004dae7b622ba5eb64f8e69e5275bef7f266b9785e5dcbf06f2cd863c"
    sha256 cellar: :any,                 x86_64_linux:  "e5a92db6734e7a8be22b65520611648f82695a5457a3e4905c1f9fa7a15efc7a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/cirruslabs/omni-cache/internal/version.Version=#{version}
      -X github.com/cirruslabs/omni-cache/internal/version.Commit=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/omni-cache"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omni-cache --version")

    output = shell_output("#{bin}/omni-cache sidecar 2>&1", 1)
    assert_match "missing required bucket", output
  end
end
