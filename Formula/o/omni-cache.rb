class OmniCache < Formula
  desc "Sidecar for your caching needs in CI"
  homepage "https://github.com/cirruslabs/omni-cache"
  url "https://github.com/cirruslabs/omni-cache/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "42e19843cb42a02d8e610d37414efe82b5080583efd70b75e29ffd45dfa6592f"
  license "Apache-2.0"
  head "https://github.com/cirruslabs/omni-cache.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80cb3659fad2f91489d36db4d668caa7df6548ec9bdebd3455c5f38a1a311b6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77410b8c9045d40a72b554b0a7a28868c5e4a5a8a8d30718ed8213e1a5fce916"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7df344d55d3c106234263af8adbe0b37e36039e06e2db1868c6513835c020975"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be06634f09a74d0690bd753649860305780403b2f836ad01963cfba7817e64c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55f3f7c34f6d03e5ab73a41639ea546152ee79988c3352ece7125159cfeb6ec"
  end

  depends_on "go" => :build

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
