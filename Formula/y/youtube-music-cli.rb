class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "f4b35f397d2d2b79d606cbccbc4043a15c8da1e5bdc7f149c38270dff9a54902"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f9cf37b86c3ea1dbcf6f31521c20b70d083ea63c771091bf76c792ee54595449"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f4908e8e886488cf742d42ea77e4b3920f5f46467523f4ce8f6b44ec23951b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9f067d82d203a5cbb8c68c224829c88c9fb027d87735a2affd3b9423d58bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a684d988adb18d85f8af00f5d610bdbd392b6136b942735d9a7255255bbbdbf"
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
