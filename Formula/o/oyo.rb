class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.35.tar.gz"
  sha256 "fa62f3578935120fa526dd1251d5e88f5cf969b833db1217d9c3f1a65501f9ae"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594d8d65c3c95cccb75a17b30216fa38a67b851720974ee95801ee60967ff0bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75693ea9abf1aeb123c49be1a7d3251cf6e75bfb097db6a5135843c4a1eac461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df979407258aa4dfd44262ae46fd7c412c37dea663e7aeba68c2f375fb9c560a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e33b34e1ad828352d94c5e4e674863c4290f4231699d5b521b773ef91ab77210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "348dd7cd61f49e6a0b16f4485e4e288729ebc358b419d56e3ab789383b9ca925"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
