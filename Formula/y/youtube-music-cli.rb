class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "77cbfe7baedbc9297f9d538fe18f1bcd71c4a35fa2ef9324b3d9113baae3b19d"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ff71dfc6573073a23f153602ef5e13f23d8fb61f9a2d9c07feeac9510595092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13407679b59550694371e25d31be66ebeb8a78b034608d82c9b65e61247315c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "478aa476f5a3e00e564b272397849802ba21997b71fb5c7c8c7f8fef513b8680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "caeb811596e2709f00a5329f79e5efddc996ef466c9c861e145af47eea43f923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e169ad2fd117f1f6bb16624ea46c45107eb9197b597c6711b874c536156732dc"
  end

  depends_on "chenrui333/tap/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system formula_opt_bin("chenrui333/tap/bun")/"bun", "run", "build"
    system "npm", "install", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match(/plugins?/i, shell_output("#{bin}/youtube-music-cli plugins list 2>&1"))
  end
end
