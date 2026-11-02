class Drydock < Formula
  desc "Dashboard for a fleet of Git repositories"
  homepage "https://github.com/yetidevworks/drydock"
  url "https://github.com/yetidevworks/drydock/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "a22ee71cb99f98b6f3d2b769cccd7f629323c9f3463cbe1914de95c6042da229"
  license "MIT"
  head "https://github.com/yetidevworks/drydock.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "92b0d009c81344067788a0def1c591387df073dbd1390b84e9c098cd5059c22f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bc9a79669ab8149806ea6ad331c5f0808b07cb83b4201761cfff51f4309207e"
    sha256 cellar: :any,                 arm64_linux:   "c3e3ea7501b58523c233a1756d1740a4a66c4620aabc3ff424f031fb5e78e866"
    sha256 cellar: :any,                 x86_64_linux:  "22706de50cc6ec24eb6b653cbb33085444c9223b9fa6db84f7ce6f9151719c7a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/drydock")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drydock --version")
    output = shell_output("#{bin}/drydock config show")
    assert_match 'roots = ["~/Projects"]', output
  end
end
