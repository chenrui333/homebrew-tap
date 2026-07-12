# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b5dc8aa505305ccc387ef1ced54a2f356f6c547de38dcefe03ce9533f660aafb"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9be2faa0a5d1450b84c3ea660d59b9e6b24710188c56f8dd958abb855b44e7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9be2faa0a5d1450b84c3ea660d59b9e6b24710188c56f8dd958abb855b44e7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9be2faa0a5d1450b84c3ea660d59b9e6b24710188c56f8dd958abb855b44e7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90c3694616996b0fd8744a2300e138d4e1416da7b1940cd2cec2825e813e61ec"
    sha256 cellar: :any,                 x86_64_linux:  "b42b22a7290a93ff8431f83a827e80336057ccb31fa67e9d0b7f92fc8511d5f7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    require "open3"

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output, status = Open3.capture2e(bin/"enola", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "not-a-real-option", output
  end
end
