class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.15.9.tar.gz"
  sha256 "8aa75163ad0eb028a3c804e6143bfa4e8522c9b6c27051659a9d3de21a7afc54"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b68881cb65a6244bb83f30c00bf91ed6df17195a039102413c300bcbf60daf1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d784fd907fc14514e7902e8bda51f7f79fa1939bad58b57f4d1f38f307d1f035"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af1756deb7df39fd2a5d2ecbe20e5d073801552fb7b7640dc5a420fc59de135b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e393daa0cd391e1fc9f1c9bed8445cee81e9cf653c23994f13eaff63801fa47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b51d7c310f45c2dd333671f081f26a45f411257bb6c0c85b13b2ea477a812057"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
