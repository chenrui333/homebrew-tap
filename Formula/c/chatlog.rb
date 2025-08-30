class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.28.tar.gz"
  sha256 "845c358f574344a4273ae1cffbc9de0642329c3561242e7d33c568b6fa0415f9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f12d10ab3f3d0378e819dd802d07ea48ed4f60d27d51b74e9201ef2ed42c3034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81185212b418ab310abb5938fdb69e54e3356458cb5b83f5b12fad67a0c534d5"
    sha256 cellar: :any_skip_relocation, ventura:       "63747235c5494bed866e22c349684ca6001a89ba9b70912bfce9cb3452f35775"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c039b52969511cfab5c14aa2695090cc5c727d47d620098705cad954d769ca05"
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
