class Gobgp < Formula
  desc "CLI tool for GoBGP"
  homepage "https://osrg.github.io/gobgp/"
  url "https://github.com/osrg/gobgp/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "c1319921ae3a8c15ca8c878929c0d9ce0adc6967a52a0c283552d50583de8406"
  license "Apache-2.0"
  head "https://github.com/osrg/gobgp.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9744603ddc8d51d1a3572e943acc5384f59a49046590348b2a1891aff11c9ce1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d930e4e251e8cdb2d0eadbbe409e0e8d2728113ebd1b02de6989fe795e5b8e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06111388cf759aea5fac0d7147976597422d3b604eca728a6703474048c03bdc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a28982ae9f07b599fb12fed2b0305db557a641a56b8a9b247e6f5f090d15af4b"
    sha256 cellar: :any,                 x86_64_linux:  "036bd9e6e10c9a29425a30b83b0d4549482bdd5f35790515c05e4ac2044810cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gobgp"

    # `context deadline exceeded` error when generating completions
    # generate_completions_from_executable(bin/"gobgp", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gobgp --version")
    assert_match "connect: connection refused", shell_output("#{bin}/gobgp neighbor 2>&1", 1)
  end
end
