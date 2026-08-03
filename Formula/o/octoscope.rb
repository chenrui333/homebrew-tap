class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a65cc1c08614eff80a13ad5d96f4fa7c6ae766df88074380c8802d45f9f490d8"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16b126bee4b3d74d900294964bb3f699fc31ca64815326589215fd508d894e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16b126bee4b3d74d900294964bb3f699fc31ca64815326589215fd508d894e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16b126bee4b3d74d900294964bb3f699fc31ca64815326589215fd508d894e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52742f21b212438d71a5cfb7d9982e251ce52fca79beb0842faed348bdbe92fe"
    sha256 cellar: :any,                 x86_64_linux:  "812658125ed366ec24ac78612271cce910671e770d82deb494c94cbf4ef2a132"
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
