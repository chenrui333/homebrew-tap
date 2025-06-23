# framework: cobra
class Dbin < Formula
  desc "Easy to use, easy to get, suckless software distribution system"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.6.tar.gz"
  sha256 "fa9e9d6bd3e209b755d79536f083a1c12751cb346a5c0a95337b403109841642"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7d1a78e99c83d60f8ccb1dddc890186c3f655a8befd353ae4dfe7f5b10a670"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d66d071b9404e4ca6c6977795230864df476df6b32c68cb5b05d4c5aba9999"
    sha256 cellar: :any_skip_relocation, ventura:       "9671c1478bb3e5249b19c61d47a3db4f63950fd3dc3a159d42de98642df53a02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b673f345d57ae2a237b9b237d73580d7f6422f03409e6a10b76287295bbc84dd"
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
