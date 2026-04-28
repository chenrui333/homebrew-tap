class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "4ed7002746374825da2a0e982fdd7b59d93c76525064ce6b184acc9f123c0a6c"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "791ee9480c3501468b6cc7a845c38d79fdd2718efc176a74d19129243cc0f216"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43b441a27d24fc48d52a83c4c53a50b8d733b8d83a43bad19e30d4af8e1743f0"
    sha256 cellar: :any_skip_relocation, ventura:       "12a1ee11006d1a43b992f7da3fa7e26f0b1e91c6c36790ee948018487679b721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53c7f7d6f75bc7a62c89a08005c1a9e55bb1446b4c456eea94dc0744ad206841"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")

    output = shell_output("#{bin}/di-tui --username USER --password PASSWORD 2>&1", 1)
    assert_match "unable to reason API response", output
  end
end
