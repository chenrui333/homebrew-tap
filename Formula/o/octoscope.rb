class Octoscope < Formula
  desc "Terminal dashboard for your GitHub account"
  homepage "https://github.com/gfazioli/octoscope"
  url "https://github.com/gfazioli/octoscope/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "072cae8eb113156ece64ca04c0c73176130331970ddb287491dc4288d788eb4c"
  license "MIT"
  head "https://github.com/gfazioli/octoscope.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072189c25eef66f0ad0b96e03f11b8b074293950880f72e7d390e958c850476a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "072189c25eef66f0ad0b96e03f11b8b074293950880f72e7d390e958c850476a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c1ac0acf2149b372cd0a8856d852802898b1f709bdec1f04df7eb5e296face2"
    sha256 cellar: :any,                 x86_64_linux:  "ef0b23f213dc561e383b371b6dc8806804cd7e6c75a8b9b6135ad48d1e9447cf"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octoscope --version 2>&1")

    output = shell_output("#{bin}/octoscope --theme invalid 2>&1", 2)
    assert_match 'unknown theme "invalid"', output

    ENV["NO_COLOR"] = "1"
    assert_match(/Available themes:.*high-contrast.*phosphor/m, shell_output("#{bin}/octoscope --theme list"))
  end
end
