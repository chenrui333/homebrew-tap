class Depsguard < Formula
  desc "Harden your package manager configs against supply chain attacks"
  homepage "https://github.com/arnica/depsguard"
  url "https://github.com/arnica/depsguard/archive/refs/tags/v0.1.40.tar.gz"
  sha256 "0db158f447f8ebf887466ae57f0d7bf6f02c8d647fa02235d3ebb5852a395193"
  license "MIT"
  head "https://github.com/arnica/depsguard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e922b0e0d19d34786ca50cb0348040b48dff1688034e8ba53c5f6a2b7700671"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eb9c30e79ddc883b719c02cebe65ad6714489637052c1b499b73b0afe6a95d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b371a84f8bf92176a35063035a50962ba053ee578cf61bf6391211c8dd99c539"
    sha256 cellar: :any,                 arm64_linux:   "82ccbde1e93db1baea3140449a8b2dbeb65f2da745daea1f305b3f203b04f1ed"
    sha256 cellar: :any,                 x86_64_linux:  "1b252b7ac6ab9866aa93304f76c0a61d6b9d833d5b27210b3b50b27fe85da194"
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
