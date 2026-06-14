class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "94c4b29951ad4ac28c99817105e8e123ba645de1ad3ff2f26db8171893b5124f"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44ff29717772528524d3f53c0e4c559ef5f470c963ee5a6e0b2f337be228a63a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44ff29717772528524d3f53c0e4c559ef5f470c963ee5a6e0b2f337be228a63a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44ff29717772528524d3f53c0e4c559ef5f470c963ee5a6e0b2f337be228a63a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b6d24eacd802bc74361ed4cd67545c53501f361a7c8d5d66c95f41551201111"
    sha256 cellar: :any,                 x86_64_linux:  "af89c5b48f5a2f088eed701c198c14ad8bcef2b1da565a80673a55b7a267edb8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    output = shell_output("#{bin}/di-tui --not-a-real-flag 2>&1", 2)
    assert_match "not-a-real-flag", output
  end
end
