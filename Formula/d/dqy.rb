class Dqy < Formula
  desc "DNS query tool"
  homepage "https://github.com/dandyvica/dqy"
  url "https://github.com/dandyvica/dqy/archive/refs/tags/v0.5.2.1.tar.gz"
  sha256 "83374237f15e8418e239684636b45b3d3de0233249166bfa3155c57c23d673d8"
  license "MIT"
  head "https://github.com/dandyvica/dqy.git", branch: "main"

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
