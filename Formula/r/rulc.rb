class Rulc < Formula
  desc "REPL and terminal calculator with plotting support"
  homepage "https://github.com/imizgun/rulc"
  url "https://github.com/imizgun/rulc/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "3acb486752fee55ed8011465df7a04bdfba3822131bc9855c950119ad3d20efc"
  license "GPL-3.0-or-later"
  head "https://github.com/imizgun/rulc.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cfe15cb65e55433836e718302f3ac9bd4e1531b872ce9b624bc54fac93a6612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98843328a55598e2145bb0e54049ad80e7c84bf77bf5e5f2adc9ffd41a68c245"
    sha256 cellar: :any,                 arm64_linux:   "e03d4bbab649757218bdd7ce713f328a83d38786ef15d102346b2398b9207d31"
    sha256 cellar: :any,                 x86_64_linux:  "05f7358764fdabd350d1329229d5203df6ae2281dbd1ba02d8c3d6ad40a91ff1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_equal "14\n", pipe_output(bin/"rulc", "2 + 3 * 4\n", 0)
    assert_match ">> 14", shell_output("#{bin}/rulc --exec '2 + 3 * 4'")
    assert_match ">> 256", shell_output("#{bin}/rulc --exec '2 ^ 8'")
  end
end
