class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "4e13865b41b604dcf589e31a9363506fd9f8ddb9e823c66c67abff8e71a2d10a"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c247703ba8789ebfd0c3bfb2d791be395ea46816496c91bd06e6d7d014a8a7ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2ec58c000e5a9112e3808503b7008c8e4ea8ff96f978282935cbbd0ee3d2648"
    sha256 cellar: :any_skip_relocation, ventura:       "a31296aadda5d934fee9e18d55c32111c8adcca658b266d691148b1890eff2c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "096c1e14abcc3ff4f58cbc16c615ce885741d9f3717354323e0abf97b2f64b72"
  end

  depends_on "go" => :build

  def install
    # Prevent init() from overwriting ldflags version
    inreplace "pkg/version/version.go",
              "if len(bi.Main.Version) > 0",
              "if len(bi.Main.Version) > 0 && Version == \"(dev)\""

    ldflags = "-s -w -X github.com/sjzar/chatlog/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chatlog version")
    assert_match "failed to get key", shell_output("#{bin}/chatlog key 2>&1")
  end
end
