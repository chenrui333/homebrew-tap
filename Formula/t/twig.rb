class Twig < Formula
  desc "Terminal-based JSON and YAML viewer for exploring large files"
  homepage "https://github.com/workdone0/twig"
  url "https://github.com/workdone0/twig/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "1d9378a2846b4b0a128a28c2c73e0d1edc48602294bc45a5664e8ec1e51c10f3"
  license "MIT"
  head "https://github.com/workdone0/twig.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2d878d3523cd135b3dc580e460a66a6aae64a5ede5e8f089a08bfd0442e72490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2038156b36022351285d2cb9ff15958e8f9a1dd90a0a6aeec58e175fbca35243"
    sha256 cellar: :any,                 arm64_linux:   "1aeec0050765bc91429397a98b301544d570221d5b12778c1854147ec10eb100"
    sha256 cellar: :any,                 x86_64_linux:  "4fd884b039fd8d6d88625a2e66ed7c597600a99926660d5c973818ceced5ecdd"
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
