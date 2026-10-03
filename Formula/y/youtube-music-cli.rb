class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "3e4b0665ac01f970013a2469880e6613c7e57bd7fb92fa7fbbc2a672655c49b9"
  license "MIT"
  revision 1
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cff18d53a73e364fb1cc5883851d64fb5f7c20cd15abe2dde8f8f35b0768342f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db4dd57b50dd5a07fa6c08b14e500afabfc665337929728c26fb62837ce339c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ebc5c422ef1bdf61bbd9d9ad8fd3d3fa0013caf7c7ebd0277bf99498be97d30c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cd6c6bcb737949b95300542298cd798d546238d3ec640363d42f6d3e40706a"
  end

  depends_on "homebrew/core/bun"
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system formula_opt_bin("homebrew/core/bun")/"bun", "run", "build"
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
