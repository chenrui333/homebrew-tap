class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "3fa957f4ce8497d989cc11676382a0aa31b02c6ab83501cc9a9653055d3d54e7"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2de83a4506e9eef099acbb979785f6f8377feff4562d3d9bded072923000584"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d73c0ed410086805ec083f045668e372bed1280acdaa2e64b524ac824f5b50a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcc5ac24c32c58d711bf73b1e2a1f78659cd8e220198bc1cb8431ff734b3029c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62a503d81692e71758233a57113a2f0dc4e1e9c519ea9edbb682fb57a69bcfa5"
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
