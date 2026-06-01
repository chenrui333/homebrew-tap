class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "4e7725ab31b650c4bb5eb9c03490de8dcf516f361a890aef56fef217868a7a78"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5494cb3077918ead913b80c749710284a1429fb206939598fa02ad074bcfaf49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "36755d54a1a2e3ff2e9b8aa8e6371f623ce507dadeb5436e899048684e7fd1df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cdef099395f6a1c70609fa8138dbdcda12c074ac79f23faeeac52f3917cba93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91c6c2b18b122d687295e7c23966964e73a1fca3cc09c7851f03e1be14562a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f5d81e61a5623fed9bb0008a802028e3a5c6f993ccb0a73f66ac952ef4c631"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
