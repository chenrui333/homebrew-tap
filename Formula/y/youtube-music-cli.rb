class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b284199f8624e257ba40d9decf91928659abe4ff6d7659947befa128032f9662"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c287ece4b3abfc94c64019362141d3c8b7445fb947664d455672b7d1eed5cef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83f77616fd119588d5a1c1de70b8b1e510060fc9d31b93f774c439184e8c5f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9d3e8f9b45659e72d367c2016dc59345d023ce06f6575ffd6af4070b3c4160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d77790ad022a3622e4ce27e7c715dc1a09c39bf38061e644c438323cd060bf30"
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
