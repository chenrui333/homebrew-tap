class Mult < Formula
  desc "Run a command multiple times and glance at the outputs"
  homepage "https://github.com/dhth/mult"
  url "https://github.com/dhth/mult/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "73ecbe739b5f8bef3508f22641771818eed4e250564a9247e84c28190f293d43"
  license "MIT"
  head "https://github.com/dhth/mult.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5487600723bd298a492a3e9c3d71012ac2b141c067f2968ff97b14d2e7b3bad1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5487600723bd298a492a3e9c3d71012ac2b141c067f2968ff97b14d2e7b3bad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e47477e4e4f1fee73e5d5cbaf35fd0e2b9536985cb03ab81819aeeafcb8e1348"
    sha256 cellar: :any,                 x86_64_linux:  "734c719612edaefc1263e1be46832bcc0823cc52a657aeac8ff0e1cd05961a31"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.

    output = shell_output("#{bin}/mult -n 1 -- true 2>&1", 1)
    assert_match "invalid number of runs requested", output
  end
end
