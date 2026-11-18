class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "5bb24e43b63bbb58c517a53a76bd91a11bd48189c80ee14864d53c61a95214ce"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7d253ece54342dbff2a759766ff709a14ca36bf5ee66015e16d45fe4b540875"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "514793dcbcf0ad050125aedfd4b0432909048fa24cc38b69937cc88cd914aed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8244d768e2d92b50e366e3a9cab45e73f60ea08abf6134209b9d3ae8b6add878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d04ccb0bea38ba6a1e4099624bd1286699025c2abce20b30aad4d1fd2900e28"
  end

  depends_on "homebrew/core/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system formula_opt_bin("homebrew/core/bun")/"bun", "run", "build"
    system "npm", "install", "--offline", *std_npm_args

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
