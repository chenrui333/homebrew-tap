class Stree < Formula
  desc "Directory trees of AWS S3 Buckets"
  homepage "https://github.com/orangekame3/stree"
  url "https://github.com/orangekame3/stree/archive/refs/tags/v0.0.21.tar.gz"
  sha256 "1edce8b1aa86a22a7ce4f8e1781eebf44ee838a70925eeaf45c7b35b3c22c03b"
  license "MIT"
  revision 1
  head "https://github.com/orangekame3/stree.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62103d1d5feec28603f6529e537827f00b9980c53f0ce55e71329427cea8d398"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9fe2c200e7756432f704bccfd3db5e7db6d4e74ee18574b2938d205e80afed4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6699b3806a5ba37ceb361383bc3d67e94fe208fcaf6a6752868ff344de0718a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc519645ed53abe7d7f57f59ec19f9d4f31f66efad2ae7361a7b6a7a920f989a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stree --version")

    output = shell_output("#{bin}/stree --directory-only test 2>&1", 1)
    assert_match "failed to initialize AWS session", output
  end
end
