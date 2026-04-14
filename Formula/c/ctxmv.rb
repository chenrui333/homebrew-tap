class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.2.tar.gz"
  sha256 "55a086bc6212afc80dab08af5f38053fedef5dd003635df5c17c1c2df4687a9a"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bc15b317e3e03e91c7f8572d8dcc38a099e48975884058dfac7cd6ac9ca236c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43288afe965c069f905d0050e44b1b646034afc2d8d572f9d9b58170dfd1a92c"
    sha256 cellar: :any_skip_relocation, sequoia:       "ba1f923ebcc2e6971201273180e5db1d13f5b9b6a58fb7365680a17c05288dc5"
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
