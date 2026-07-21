class HardcoverTui < Formula
  desc "Terminal UI client for Hardcover.app"
  homepage "https://github.com/NotMugil/hardcover-tui"
  url "https://github.com/NotMugil/hardcover-tui/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "cfcccf491963e3dbc7edf84ce67a7bc90188ca7ef6387cbe725e12910becabfe"
  license "AGPL-3.0-only"
  head "https://github.com/NotMugil/hardcover-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baecd7d47fc884111c65bc8defd08aa6e82e8dd198d517710e083649ce9c3c57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9febcb8b9c6ad176f906ea6355555f30bddb01196f0383fa0d9444c735152855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a89bd261c81072082bb8ef849a44ede6267ab36aa7b0d06a0af9d638874a694"
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
