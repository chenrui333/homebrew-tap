class DiTui < Formula
  desc "Simple terminal UI player for di.fm"
  homepage "https://github.com/acaloiaro/di-tui"
  url "https://github.com/acaloiaro/di-tui/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "cd8abe4d3f0e49ac83fb45058c2579dd939fa2156685c052b41235e978907baa"
  license "BSD-2-Clause"
  head "https://github.com/acaloiaro/di-tui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "027d082eabc4d9b4a40ffb89a93b84ca531ec77227c3c201bf11b2ece2a77ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027d082eabc4d9b4a40ffb89a93b84ca531ec77227c3c201bf11b2ece2a77ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "027d082eabc4d9b4a40ffb89a93b84ca531ec77227c3c201bf11b2ece2a77ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14edead28c6888118e4aa8fc47edb1003490d05310577e4c6fc1495dca143e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "491069fd41261e9e57614232731163a4d6c07d05700f30abd2c0ccb89fa20c43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/di-tui --version")
    assert_match "Usage of", shell_output("#{bin}/di-tui --help 2>&1", 2)
  end
end
