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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "688a87ea6f8bf00219e98857cd7addb0ba19deea6e9beb6aa31067f6bb8d923b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "688a87ea6f8bf00219e98857cd7addb0ba19deea6e9beb6aa31067f6bb8d923b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "688a87ea6f8bf00219e98857cd7addb0ba19deea6e9beb6aa31067f6bb8d923b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b372d83eba832ce93db393a4e57f989aadda4c3744f8314c3b7a5bf0174adc69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c4360f5564dc8297585655e1c200b2c5da7b81964f2c67eb2f538046d1f78e0"
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
