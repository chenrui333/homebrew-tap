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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "69cb8add34a17699983a1298d937acd5586e5148acde830668f73f0fa470d45d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c0e02b9d9180ae9a54b32f4faddaabd59417d1cedb467b4bf0833dfcc7495791"
    sha256 cellar: :any_skip_relocation, ventura:       "2f453936165d91171eddb7f75fc11dcf039930d29adf8820596f0ee95d01393d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77beef1d845c79247b5aa92f5d2181c360e06e2470ebfe5112d568dceac232a8"
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
