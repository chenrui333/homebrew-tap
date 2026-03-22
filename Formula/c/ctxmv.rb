class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.5.1.tar.gz"
  sha256 "691122bc7dcd0dc44ed3ef1a5adecd9e66f71eb5d5a1fb2553a13e99eaf4751c"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d4f34954893567c959b978602b54a2e65e5647893f654ae9d0105855cc996a9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae89236b77c9322b1af0be57ff374b62f6d9fafca2df63e551eb54e6d270e34b"
    sha256 cellar: :any_skip_relocation, sequoia:       "a758a93cc663a3a508e349239b4e40571df2062674192f340e465148488603fd"
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
