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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fa74b621afc07d42a7b8ee6a41d82e5761791689580f503eb839d5d5c03a648"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa74b621afc07d42a7b8ee6a41d82e5761791689580f503eb839d5d5c03a648"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa74b621afc07d42a7b8ee6a41d82e5761791689580f503eb839d5d5c03a648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8a7437d6ee879161f764e9c0da93cd1011f793043ce13ae59c9b66a1ea24a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da9f6bf3d60e295539beee7ee7ab4c457f0a25697502a434471595191998d039"
  end

  depends_on "go" => :build

  def install
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
