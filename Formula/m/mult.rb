class Mult < Formula
  desc "Run a command multiple times and glance at the outputs"
  homepage "https://github.com/dhth/mult"
  url "https://github.com/dhth/mult/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "73ecbe739b5f8bef3508f22641771818eed4e250564a9247e84c28190f293d43"
  license "MIT"
  head "https://github.com/dhth/mult.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ab6c845794d8ec029fc62d8ea1233097e778ee66127fded81043d28a24630364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab6c845794d8ec029fc62d8ea1233097e778ee66127fded81043d28a24630364"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "967bd2bf3839420614bdcc6ada9d299d8b5e2fc0ad5abfc6b86d19d546efab60"
    sha256 cellar: :any,                 x86_64_linux:  "c1f175d1b8d04afcc74d7d5e27f2b9df926b34746903c68a8556aa3e73458c0b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/mult -n 1 -- true 2>&1", 1)
    assert_match "invalid number of runs requested", output
  end
end
