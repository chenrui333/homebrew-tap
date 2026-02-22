class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.31.tar.gz"
  sha256 "96089ff34ace4742878a5751eca74ea36a5687e0a8d834fd48089bfd7fd7dcb2"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405bed6fd882d44102d8df2d5dec016fef509efb01725fb5eba66470043f2a75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d53e5117f8c1aed16fecf38f83e76490949fd96a9e2c83a5a6386b9a4e77f73f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646a15cc925f67ed856357da24829dfbbece232e908453ef863fae54d0b07c2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f592853e0281bece1167aabacf2b6f968e9700831be1f6417ba1ad9a7a39fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d40a8550ae4c7b25fc7fa251f7a5d86b01d81c7a0903467cbaf86bd4e038ea1"
  end

  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "exec", "--", "tsc"
    system "npm", "install", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match "No plugins installed.", shell_output("#{bin}/youtube-music-cli plugins list")
  end
end
