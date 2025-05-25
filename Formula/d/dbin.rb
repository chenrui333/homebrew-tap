# framework: cobra
class Dbin < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.4.tar.gz"
  sha256 "4bbdac203152c211242b5eddd8cdb73871607a9fd7217a5fa52cfe5408ef021d"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d74ffbe2b29a8157733e569bedf0093a48c6d2eb831fe8bd0f2ff8f77d464448"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28e1844aca4237ef3e5a3c909f9f0d460b8df8185b0cc5409a6b93ebf0bc2555"
    sha256 cellar: :any_skip_relocation, ventura:       "e70c5ee9457e675f4aebb8c5cf6d6796d9a51134efabf48f40c02b8f06feb8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22aa7f528324dfb6ac06da6a31bed40bed5913729dd1580205c199ff8bc0d4fe"
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
    assert_match "Failed to retrieve full name for 'bed#'", output
  end
end
