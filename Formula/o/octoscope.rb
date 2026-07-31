class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "13a7ded570b392412d84354499c769f03ca18c8ab9cf570542d0b7d358b5ac81"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc02f48908df3b33a01310be477a2dbd485b7dc5e4f38283ea19365827de7de3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc02f48908df3b33a01310be477a2dbd485b7dc5e4f38283ea19365827de7de3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc02f48908df3b33a01310be477a2dbd485b7dc5e4f38283ea19365827de7de3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2b14ff7b9512e297792735f02cc83f89154177b87851c56f34258272654aaeb"
    sha256 cellar: :any,                 x86_64_linux:  "851db55cd0622ff7777a7f4e613b48c34c58726404a764a2a9dec70845da40f1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output
  end
end
