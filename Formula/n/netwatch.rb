class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.21.2.tar.gz"
  sha256 "024424d64db31c856f15e4d010ca9f9ba422ef38996f8daebe70c1133b442428"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d452051ed22c1f6c85972413d1a81c106e86657f7ed8948e653b5d8afa4a295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8870b80ec98e8b9b5a600a079996bf45908db11243bd0ffa6001b903c1df96be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05c9eddeb2e3066b9b1ed3d96cbd46e6b0e2f6274d49e3ea552c2ac8358e15c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "995873601f280aea8f58f83b70c488f8c9c24057e2fd248a52892d66573af9a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a052f30f34007cda173b85c7e599734b915526cf6bdff6a48869d13ae17a798b"
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
