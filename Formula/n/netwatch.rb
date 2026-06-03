class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "a608de7cc35e2d9a367d51c9284379cf2de812f62e36c3523b1048c0e72942d9"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "23f1ecbf7eae69568cfbac1c5ab4524e1abb26e05099f914c334d195908da1c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "585dc8b94c59711286cb0b346613a0553d200677c923a70fb7f5c33b8d53caf9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6318e5fc01e36b20cd9f98b6607ac444a593dcbbacc65f6279038631c1a7ecfc"
    sha256 cellar: :any,                 arm64_linux:   "88f62d05e98ab64df2a2e3acb02da755010706e71ae52f44e3691fc672cdfc90"
    sha256 cellar: :any,                 x86_64_linux:  "b34d67a2b650e9296991dbff287f21ff166d09fdec3093774e21795b0751013f"
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
