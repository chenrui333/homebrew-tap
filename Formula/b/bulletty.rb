class Bulletty < Formula
  desc "Pretty feed reader (ATOM/RSS) that stores articles in Markdown files"
  homepage "https://bulletty.croci.dev/"
  url "https://github.com/CrociDB/bulletty/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "855aa55629ca0846b1b50a87f2c18c2b7f76d8aa0fbd276187b70a5cb3bc34da"
  license "MIT"
  head "https://github.com/CrociDB/bulletty.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "890392ad15964df31fa3afd729861838b4ab8d04e769864c3fca9b06e8f27ace"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe256a502532d198646a33345622957c256ff15ab70509a7ed85e8ac39129d58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "202dcaaaee84148833edd05cc739beaea6ccfaafff329de911fec07ece2f32d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc68c9d01a17fd899b840cb2426750e5479e3b611d1d8c99a76ab47bd31df4ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4825c6b00e7443c9e4ca596de4b350309565f62ec451bb9d7beaa3c7de246a0a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bulletty --version")
    assert_match "Feeds Registered", shell_output("#{bin}/bulletty list")
  end
end
