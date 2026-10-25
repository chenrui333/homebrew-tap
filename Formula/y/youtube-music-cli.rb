class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "85ec42ad42c5c73e37bf5b84fb190d9cccd5a68babf7e634e78c5d22b32535e0"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3a7e12927fc6c27d55d5c9b5b95982eaf6cabb22a2f2dbf2b45a15fcb503f7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4cf3a5adbe8a1b92d3d7f4bfa2b678b9340bbd7e022ac15c1db446aff9ee5f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ab992bea129a559de0aac51803e9d894eb4661e567da00304129c14ef1d71da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aee78332ef1b969bf3f36d2b28b76f4ade6f00d78c1ab7aa116075d1da8db9ab"
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
