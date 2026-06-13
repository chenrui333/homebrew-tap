class Depsguard < Formula
  desc "Harden your package manager configs against supply chain attacks"
  homepage "https://github.com/arnica/depsguard"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "e4730a6a781c5fefc20c28a7cafe6907546498d0f4aa12cca9bd7dee43877196"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b97b099c12d7a6cce934318903cc145787221aa0bf29f0e34c78bcb8c7275780"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e3ac6e3e81c45fda7fff07278471bd7687b2d5fb86ef64d197565c6edeffd9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7780252221f4e7e639bd836d8d6a22e011440cce4115e647f35c4a38cdac437"
    sha256 cellar: :any,                 arm64_linux:   "2b1aade99cdc800b1846b1506cb600b95d020da80d09b0cdf102032193a831e5"
    sha256 cellar: :any,                 x86_64_linux:  "ea873a9770700c792a107d7ed288e454de90ee5092337469108fe11c78e509c6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depsguard --version")
    output = shell_output("#{bin}/depsguard --not-a-real-option 2>&1", 1)
    assert_match "not-a-real-option", output
  end
end
