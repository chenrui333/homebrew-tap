class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "3357261a4b27fe2a0a236aa34dcdc390275821377b620e0f03d69e5529b3db67"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99fee5a76703a55788f1c956752056fd203735b8e7758c2be566384441ae6861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4b0dfa0ab27d539a799c6d8ac6b8ade907088ef25c008a2eb888ed1fff8e173"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fdf5db19425b1ff0800815f91da8ebe436768bb1a06d1a6f096a6f7a7d2ce87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5b7c101dc6f95d878097226b7ecd46340b5337d137efa1a3eb2baf5f25af12e"
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
