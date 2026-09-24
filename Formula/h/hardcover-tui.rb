class HardcoverTui < Formula
  desc "Terminal UI client for Hardcover.app"
  homepage "https://github.com/NotMugil/hardcover-tui"
  url "https://github.com/NotMugil/hardcover-tui/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "3c42ef168b4cfe70f9c51726c2e2185156c9ee1e1b909dfcaee2dbcac218102d"
  license "AGPL-3.0-only"
  head "https://github.com/NotMugil/hardcover-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37b12d5f1d576663ae49fa9899a589ca06bbb6bd80995b1a4d6f6645df1df8d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b12d5f1d576663ae49fa9899a589ca06bbb6bd80995b1a4d6f6645df1df8d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ea7dbca77d2ff22ffdd183350d294ad371cbb2d134b9ce5f167aaf027ba6b6"
    sha256 cellar: :any,                 x86_64_linux:  "c3820e0dc82067de4c4f604256a52c93a4e1011405c05ff83f08e5929e7d5922"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hardcover-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hardcover-tui --version")
    assert_match "Not authenticated", shell_output("#{bin}/hardcover-tui auth status")
  end
end
