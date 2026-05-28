class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "9b2874c9ed823820c6e550eded109c9c7bb425f45fb45c79c7c2fd713ea1f913"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf5a11e70e7e7bf0797d6474c3706d8064a13b687c08d0652c68e143326ee566"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5a11e70e7e7bf0797d6474c3706d8064a13b687c08d0652c68e143326ee566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf5a11e70e7e7bf0797d6474c3706d8064a13b687c08d0652c68e143326ee566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17f711307b3055ced6c7956c1a85a867b3c0a7f33fae709fa0484d2c266dcdbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e200d1d3c30261520a16b680d17c98fa0c9fd3f38d82fd3ac9760cd01064f7de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")
  end
end
