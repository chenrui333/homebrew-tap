class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "5d9ea3afd13a8a42c30c0779ea5a44b2f0e83c3373206c7ed96d3589f17c2ddd"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfab623c6bcef58cfeb703d013135736654607bfa6f7d0f57432aadff9717625"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "305a4f6b7ca4dfc597622259f0818223be6deea3878629895cf0f3adb64ad82c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77fcad2879fa30eb67f4b1509869aa9ae9fa02551d5008994ae90f68d6708a29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0eedd983d757bff02d4457b04575a1dd62c0abd89580170ab3609634501e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8955bc4e3291ac0458c6e65f811a883f7c755f0d7ce4af135921d86f0f8785eb"
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
