class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.3.tar.gz"
  sha256 "138ea8ae57274afda9623ee878c6366d4f0e4b2b5b2b02c2f2dcd0f63a1c6387"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7cd45371b1025b2b5bd5e1d7121a032ff621d417091192fe0b447a690b6f1ac8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d2dea2842cbca745e4c7ad2635de4917843f44a705f5e93f808dd1b021a576e"
    sha256 cellar: :any_skip_relocation, sequoia:       "1ee119d4ed87dcd8b9cb064a06e3cbcdf6c947ac084d66e59a38c61267f7d37f"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/ctxmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctxmv --version")
    output = shell_output("#{bin}/ctxmv list --source codex --project #{testpath} --limit 1")
    assert_match "No sessions found.", output
  end
end
