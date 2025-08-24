class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.23.tar.gz"
  sha256 "5b11a3208102c48309595bd90e2b2e1cacf1fc4ab51aa7fcaf136c22f27e5f5c"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "406963ce57b2339b9bde61e91ffa55d61ed3f73a5786e5a89b83868fa285f5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cc57269cc4ba3f01a8d0e36eb4dbecd3b58a5e4b76d22b8c313c07b182e0fd5"
    sha256 cellar: :any_skip_relocation, ventura:       "1aedb98457b1429cb412512c302f66845da53cc30c71b5ced25de8aa0c6e8c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbb614077a8ece9cd92bb218d90be29bdb12d4ac069e9118d1d16ce52da98bad"
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
