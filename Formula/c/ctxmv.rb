class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.6.1.tar.gz"
  sha256 "f90927acadf409844ec0401ef4eb8aece117acb569ae979578c926e56f5d214d"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1222012331a8f4d6449606309e541413c6e49f0d544835fd7c7c19bda42fdd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46dfbe76bcae22141a6ba3981cc66ea789a8ccff16c24b151aa8fae5b98b8de"
    sha256 cellar: :any_skip_relocation, sequoia:       "91911c306f99d7523b45d30d1985693c80dc2f2424f15cbab17512e79012c42d"
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
