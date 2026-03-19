class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.59.tar.gz"
  sha256 "049ddceca117309010c74d193dfcc3a99dde1efff2a544226841375f49113cc5"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42772ba93e5e5811578eed5e5fefb5ce9710ca46a3cf01d1dd8be2e0c74f8eb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7442f4d3256e368c96bfb41b9e0570c6d4bceb5453f8ff79cc8b6204becb1257"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd0ff5e96a063ad63c395268051c88fb08908f303270ee74c6319888f50672eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "502f0b65c5e42c0211ebe0a5bdce25439c012eaec091548612c1fa18c07470da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cece14745741fe3015ead799fc9d343932d131509f8d0fa10f0e52cc9b7a366f"
  end

  depends_on "chenrui333/tap/bun" => :build
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system Formula["chenrui333/tap/bun"].opt_bin/"bun", "run", "build"
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
