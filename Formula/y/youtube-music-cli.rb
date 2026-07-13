class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.94.tar.gz"
  sha256 "361c8bb2bcb84b5b3778064fa27a2cc4eb28d77e5b6aeaef0f605f4c21673661"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43d5c8e4824804e722b6a834e8045dcee88b035f59c9b46f7456f2679101ff7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53b9f655deaf17e45570ae0447555c6dd42e340eb455b60a053ce5e30adf6c29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c18bcdc3b0ba1bf5d41b544fd94defbaea0bb91d9c0a004897ded0a12cc3db55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "271dba0420b0204f15936aea713a600e18a9a397098ca283f27e61b29c40f456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d66cd04b602640362b2cab8215962dd4db5fd94f1641046e5760f8e538da6b5"
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
