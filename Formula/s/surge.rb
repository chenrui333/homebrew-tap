class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "3cfb3cc68d360f370863f4d487b56ef56f920a3add0fb9d35da1ab3303a8d947"
  license "MIT"
  revision 1
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ca2cd544f890cb39ae896d2ad3c28d2ddd033fede567aedd60a2f0cf54b59f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ca2cd544f890cb39ae896d2ad3c28d2ddd033fede567aedd60a2f0cf54b59f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ca2cd544f890cb39ae896d2ad3c28d2ddd033fede567aedd60a2f0cf54b59f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec1d86f79a41e71e13b48a2c81d471dd1184375e9667ffa6f0dbd207f0ae4f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e763101467458d6de7d155cc4d845d479d2126ea39aa131b1aa800e1507ce571"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/surge-downloader/surge/cmd.Version=#{version}
      -X github.com/surge-downloader/surge/cmd.BuildTime=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"surge"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")

    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"
    ENV["XDG_RUNTIME_DIR"] = testpath/".runtime"

    token = shell_output("#{bin}/surge token").strip
    assert_match(/\A[0-9a-f-]{36}\z/, token)

    assert_path_exists testpath/".local/state/surge/token" if OS.linux?
  end
end
