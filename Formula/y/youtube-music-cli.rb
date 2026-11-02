class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.7.tar.gz"
  sha256 "b892a9439d91a35e1ca9bf52b016a45da6f300f525ec969fb34c5b92866470f1"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d159ba1bb0a8ba7ead93ca196cccd44f8f72e699197f1d012f2ee5341c923484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22ea49ba551c04fcda5df421fd788a21b2d0453ed5cb58030231e32fcb05b032"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8a0fd0c4d1617127c840763d5db9a25d7f5102836f99682d9d04113833ff79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c93751c84e38af59b39c56d8324cc439ae62dc3331fd4f1c963f70a8e7aeab7"
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
