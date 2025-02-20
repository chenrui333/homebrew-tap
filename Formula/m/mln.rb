class Mln < Formula
  desc "Modern replacement for `ln`"
  homepage "https://github.com/tkmru/mln"
  url "https://github.com/tkmru/mln/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "8d57a09b95be6bd24f7c7c90be19e6ddf94640d153fd157f41282ee64c767dfc"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "464c755ad41abe1509da90f7874114e87035f4812e717c8f61a070665dd3c750"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75cd67fb141428f7853246bb9ea7c6d8b05a28e49d7c512666a6363c2d28824a"
    sha256 cellar: :any_skip_relocation, ventura:       "bb6e779e17cd7b7c4f3eb4a3659266ca92aa1267bb6bd880b24c853bc210bd41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80029ad3aaad27ab62551b9eec5b9b8f681c274946d5e753bb77e3b74e1bf846"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"testfile").write("This is a test file")
    system bin/"mln", "testfile", "testlink"

    assert_predicate testpath/"testlink", :symlink?
    assert_equal (testpath/"testfile").read, (testpath/"testlink").read
  end
end
