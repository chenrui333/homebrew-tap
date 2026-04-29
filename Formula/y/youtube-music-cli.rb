class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.73.tar.gz"
  sha256 "3e3db86844d4dafeccc64e4102909d0b7c7fe360f1b1a31ed0212330e6653441"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "757ee71dfb1b9747cc43f011051e5c2924d5563d600a1635d69719890abe1183"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffdb8322b987db512a4a3bbd3febda3806028d1e9a6903959548072f4e5b9db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "546680e561730a5c411a75ff6038fb368d662735c8e604d069cf0b3b883d4795"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2b9bcd1e2c533ed4ab2234d3b5f6846ff97d6272a51fa56625972e612eecbb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1174167a2bf7085027cd6c086f86046cd55b4bddd63acaea96f8b66f2600856"
  end

  depends_on "chenrui333/tap/bun"
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
