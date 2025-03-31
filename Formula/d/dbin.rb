# framework: cobra
class Dbin < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.2.tar.gz"
  sha256 "1306455a19ce86916b2159c84dfc669626feeb6b9cb70119689ba21562e7934c"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f7371d11fb7734346d089860f969cd3ad66e91a0fdd7ebc5ad013718e035584"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad9dbf477247e3f125c2bd147765265efc7db1225b1f1d7d83f36f20ce193bee"
    sha256 cellar: :any_skip_relocation, ventura:       "84b179d6677ad1e2f7361a76dabceac3cecd5bd80e1dc36d1a4e790bf37ccbe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fd61ebcd6c495daf74d76271f81c405381047f0c2b640b357de2cf65c0af4ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version")

    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "Failed to retrieve full name for 'bed#'", output
  end
end
