class Hygg < Formula
  desc "Simplifying the way you read. Minimalistic Vim-like TUI document reader"
  homepage "https://github.com/kruserr/hygg"
  url "https://github.com/kruserr/hygg/archive/refs/tags/0.1.20.tar.gz"
  sha256 "da3c0d659d3e599fc640e42851da52abd194ee38a74c5d1dffb629a68ac19f91"
  license "AGPL-3.0-only"
  head "https://github.com/kruserr/hygg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "533ed3d0dba8fa72df1df234cb7d4041e87737487d2e5b9eff9074cd85c3a55e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af87b59a7290b9496b41b66e077af737439d8afce0cb14bcbfc56dcef8323f5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ebffaccf2ff84966ff81216a2c7d925843b8ba39930b0a6bc248a7e0e7b5358"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7277405951974620656d620b001858028c5b69b69808b7a675cb173bbdd4ffd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "580f088592d34ce8e265c3acfd263d554e1ca4dc97b801dce01db9126c83265c"
  end

  depends_on "rust" => :build
  depends_on "ocrmypdf"

  def install
    system "cargo", "install", *std_cargo_args(path: "hygg")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hygg --version")
    assert_match "Available demos", shell_output("#{bin}/hygg --list-demos")
  end
end
