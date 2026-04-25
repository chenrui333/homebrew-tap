class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.13.4.tar.gz"
  sha256 "12fb90dcaea96bfb906b65e00e925a54ceb22045b3ca96f82b92dbc8e5481097"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "206a2e03c765dce5e61107597cf821a472d47d04e0bd4aa0e17cbf95672ab8df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "206a2e03c765dce5e61107597cf821a472d47d04e0bd4aa0e17cbf95672ab8df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206a2e03c765dce5e61107597cf821a472d47d04e0bd4aa0e17cbf95672ab8df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66dae02f6c9bc3a6cc01b690551892856e1351bd1acf99378705ac962c6a404e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "305ebb141d9d8213a32d1cc7acc70ef7dd93d7a395b2a2597569e11febaeb6c4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    assert_match "Usage of", shell_output("#{bin}/di-tui --help 2>&1", 2)
  end
end
