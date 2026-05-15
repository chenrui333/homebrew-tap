class Threatdeck < Formula
  desc "Terminal based threat intelligence monitoring and alerting platform"
  homepage "https://github.com/gripebomb/threatdeck"
  url "https://github.com/gripebomb/threatdeck/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "f849fba04915722034bb1a4600bd33d4e3677a1de6b8c99e1ccaa89d2ff380bb"
  license "MIT"
  head "https://github.com/gripebomb/threatdeck.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dedef5a6227e312dd45ee947213332d6ce7a6760b5ab3a90b88e5206afbbb474"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7b2e59ed164685b604b8b5cd69596b243392f0e7d63b2e63c36dfc5642186f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22676185a17f1e8979fd7ac883b6d58b02a38c6f1e0be02894ab2901a486a886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c0ca6234f15e871b6d582844d78bca91d8e9b43d0753f5ea71a61574f5da0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6b441f71570704620d38eb34b17d64851cb1717ace16d46a13e1cc1d652ce8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ThreatDeck --version 2>&1")
  end
end
