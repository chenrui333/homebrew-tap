class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "23d32cf3842ddc8ff1c311904d295e6027ff2a008d2525c0fed78a1c4641da2d"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ac01a76d06f9d6229b4e1127c3cd3341d31ff8e2bdaf1215090c37163e10330"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ac01a76d06f9d6229b4e1127c3cd3341d31ff8e2bdaf1215090c37163e10330"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ac01a76d06f9d6229b4e1127c3cd3341d31ff8e2bdaf1215090c37163e10330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a2dbc2604094309dcd7f30f96d4dfe0bd5b099827cc7f7eb33b6f6f9d939e3a"
    sha256 cellar: :any,                 x86_64_linux:  "aa171237698997e1ab27bedefa38c35c391206b6107003f23f1b2037e7dc92f3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
