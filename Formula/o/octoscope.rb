class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "47ed13cc272838192e0ed59bd7fb3441f4d0c1595c1116b00fc69b64b3578a9c"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603664bf6a0169ec86526c7344dd97256f85f63d85a152559cb62d69435ea0ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "603664bf6a0169ec86526c7344dd97256f85f63d85a152559cb62d69435ea0ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "603664bf6a0169ec86526c7344dd97256f85f63d85a152559cb62d69435ea0ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680988c8512dae3a2a06e8f11764bc5029d76e4cc3bd53524f84f7dc30868edf"
    sha256 cellar: :any,                 x86_64_linux:  "86fcda1e57e785dbc6eef627e87a7c24c0f2fa1574af4d95da0aaeb79b708127"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
