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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3476a039cffd8a005848860f6664ada168ebe7ac429d66643cfdd8d176a14472"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dfaadb63ec2277161f3de00966283816c8b543a47e3c5ead28c41f56bb25c764"
    sha256 cellar: :any_skip_relocation, ventura:       "a9c80eb1ab761b39521479ba79fba438d4fe0d28457e35a4269b643b529202ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf29d326f96230fa64bca04e56af95ad948026c05a2880d68970a1a01656c15"
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
