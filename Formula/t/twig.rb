class Twig < Formula
  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://github.com/workdone0/twig"
  url "https://github.com/workdone0/twig/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "91284428e805ed14e8fedc80adadd258c5641cb6d0aa97e63855891cb80f9a63"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78e77011aa7495612c6788c36dce0679e944f02f6e0936398ebf2b23901f7a1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb730a49e0ae4612da46eebeb9c8d4eacaa6832411ebcbe429f961a680347276"
    sha256 cellar: :any,                 arm64_linux:   "8d3198f8cc332160624e6a080adb37a4e1ca6a678f61183c4601a56d3312c497"
    sha256 cellar: :any,                 x86_64_linux:  "6cd16b88807a01365366b243baba53feeb770092f81b0e8d5918f6b2528d387a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"sample.json").write <<~JSON
      {"a":1}
    JSON

    assert_match version.to_s, shell_output("#{bin}/twig --version")
    output = shell_output("#{bin}/twig --print #{testpath}/sample.json")
    assert_match '"a": 1', output
  end
end
