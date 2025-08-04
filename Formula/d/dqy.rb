class Dqy < Formula
  desc "DNS query tool"
  homepage "https://github.com/dandyvica/dqy"
  url "https://github.com/dandyvica/dqy/archive/refs/tags/v0.5.2.1.tar.gz"
  sha256 "83374237f15e8418e239684636b45b3d3de0233249166bfa3155c57c23d673d8"
  license "MIT"
  head "https://github.com/dandyvica/dqy.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8fc546ffb292cf0185749d3eb3cee0ec2560afce18a0a0972be78a11b47daa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "905bfed8b212d1de1c1839e12fcb063a7ea4fda01600cd8875db9e310682719a"
    sha256 cellar: :any_skip_relocation, ventura:       "fcef4aa3cfdaa456b3fcb9d24e4e9d24ce4dca03b63e74981fb814fb21fe1f8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "862f8bfea3c3b152ebb8e11474bba45fd2bda690d7e4ec0526ff0b98527b475b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # assert_match version.to_s, shell_output("#{bin}/dqy --version")
    system bin/"dqy", "--version"

    answer = shell_output("#{bin}/dqy NS example.com @1.1.1.1 --short --no-colors")
    assert_match "a.iana-servers.net.\nb.iana-servers.net.\n", answer
  end
end
