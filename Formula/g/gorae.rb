class Gorae < Formula
  desc "TUI librarian for PDFs and EPUBs"
  homepage "https://github.com/Han8931/gorae"
  url "https://github.com/Han8931/gorae/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "c91aa31bb27abb12abfec28f124bd778bd80bdb9ebb34cc23c563ac59d31416b"
  license "MIT"
  head "https://github.com/Han8931/gorae.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a164dc3d75ab3aef70a5d432dd1bcf14ded1f042ef719acdd71a232f6da5ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39a164dc3d75ab3aef70a5d432dd1bcf14ded1f042ef719acdd71a232f6da5ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39a164dc3d75ab3aef70a5d432dd1bcf14ded1f042ef719acdd71a232f6da5ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e294f9894f9607b3775333f25a2dcea581d7a37b072268c766bc34196490b70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b66a77965007eeddd23415685e7627ba473ebe3ec71c4b1e69bd1e65f7df63d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gorae"
  end

  test do
    assert_match "Root directory to start in", shell_output("#{bin}/gorae --help 2>&1")
  end
end
