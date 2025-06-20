class Spok < Formula
  desc "Lightweight build system and command runner"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/FollowTheProcess/spok/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "31a4569fdecfc5d8e4ccc370d5ff7dde10dd375d94ac4706169b8841df82bafa"
  license "Apache-2.0"
  head "https://github.com/FollowTheProcess/spok.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea86d6426d82ad38e56d33050ceb677e320264e964b46ceea4933d2bfebf4e2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f199a134aab9a283c395ea2d6230eb333aa869e2698bb0c9560e5379d6925a8b"
    sha256 cellar: :any_skip_relocation, ventura:       "a7c8461500328e91a43ea631632d8d136b4de894e71ec2d40cdc41ac19ab88c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "145600b19f7c4ebddf1f4ba1aa02c6da47cb204d498eb570fc75ce5995b47dca"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/FollowTheProcess/spok/cli/cmd.version=#{version}
      -X github.com/FollowTheProcess/spok/cli/cmd.commit=#{tap.user}
      -X github.com/FollowTheProcess/spok/cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/spok"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spok --version 2>&1")

    system bin/"spok", "--init"
    assert_path_exists "spokfile"
    rm "spokfile"

    test_spokfile = testpath/"spokfile"
    test_spokfile.write <<~EOS
      task default() {
        echo "Hello, Spok!"
      }
    EOS

    assert_match "Hello, Spok!", shell_output("#{bin}/spok --spokfile #{test_spokfile}")
  end
end
