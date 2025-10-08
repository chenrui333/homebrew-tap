# framework: cobra
class Dbin < Formula
  desc "Easy to use, easy to get, suckless software distribution system"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.6.tar.gz"
  sha256 "fa9e9d6bd3e209b755d79536f083a1c12751cb346a5c0a95337b403109841642"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  revision 1
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11ac9b40c6dc265c113ed1c7f476a8bf72028c47394dea71a661909e6f444a65"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bd14adb5c17ae52c9acb8a8ccd49d2750d92035fa0563d22ae1f6670d96a31a"
    sha256 cellar: :any_skip_relocation, ventura:       "9e2af5357521035aa761897670439bdc015385c20925772946317d1a5ea96e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57fc6d5564036517bee8c81682d07017df62cef9f7d76c3aef62c9eb5f04f595"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version")

    # no darwin dbin metadata in https://github.com/xplshn/dbin-metadata
    return if OS.mac?

    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "Failed to retrieve full name for 'bed'", output
  end
end
