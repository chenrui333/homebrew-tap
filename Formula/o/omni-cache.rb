class OmniCache < Formula
  desc "Sidecar for your caching needs in CI"
  homepage "https://github.com/cirruslabs/omni-cache"
  url "https://github.com/cirruslabs/omni-cache/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "42e19843cb42a02d8e610d37414efe82b5080583efd70b75e29ffd45dfa6592f"
  license "Apache-2.0"
  head "https://github.com/cirruslabs/omni-cache.git", branch: "main"

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
