class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.10.tar.gz"
  sha256 "5bb24e43b63bbb58c517a53a76bd91a11bd48189c80ee14864d53c61a95214ce"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5c1beaf2b86a4d12565c2ed6c17373b0e54963b125cb32662bb446e62b6a669"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cdfa5971f28388466c31d844d00fa99edc72be556959886e2bbdb88819cd311"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "637c7f778e34ab7fdf14f25d0e6a47e2358a178d07b2d70cf355fa329dfbd0f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33dd30834f5ce4c00fa7844d91bb738f64be2764ca9e4361c573e49f949b879e"
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
