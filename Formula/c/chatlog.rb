class Chatlog < Formula
  desc "Easily use your own chat data"
  homepage "https://github.com/sjzar/chatlog"
  url "https://github.com/sjzar/chatlog/archive/refs/tags/v0.0.29.tar.gz"
  sha256 "3d89406c9b19e94fa3b0f7a8504d60233091eb1e86c95af69c8f24bf78e16755"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "803214f36bd38e52e250f0bd0e9831d55b8890f0a58efbc3c0c8eb7f017218d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05eb87eaac75446646f479eccf6b7ba3e3a38e72a399bfa1d370d2ea8b96f59e"
    sha256 cellar: :any_skip_relocation, ventura:       "ad5a9e59cf14d4f0cca4ae6b0c423ca659b6597b365ec900103a9f1722ec98c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5355144300993d8477bcdee6c28a7917dd03d5885e74f0ddedc984090bcaed51"
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
