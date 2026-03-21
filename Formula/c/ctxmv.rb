class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.0.tar.gz"
  sha256 "77254a014bb9dd14a79122f7a05cee3880f53b99f5bb912f4c5b1170e79405df"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8578a3f72e0129336c37c77bf5ceb65b5c4eb7c3d4bd556c1777042c22f1257b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a68f20f759f60d8ecbbfe5a32b2385c441a34707a507e6eecaf2262a1a7ba39"
    sha256 cellar: :any_skip_relocation, sequoia:       "be2887e62d4c4289e45e26f95ddf771ca8512ee87a5b402435f6132f2875aa19"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos
  depends_on macos: :sequoia

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
