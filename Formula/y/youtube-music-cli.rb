class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.3.13.tar.gz"
  sha256 "6c1429e96eb32ea79226ff46599d5e2340858f485b92a6db6d1f1ca632a259de"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "dd99b91c3dd93b41b026c474db98c95a96fc78a11b5361b6a2793f2486a99c4a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90013163628afec8f437f47ba20200c6066b8080d8fc9cdec5a08cbd3f891d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59abe2378b9bc62382ca6968a8d47a491bee619850a7ff7e78070f0764e4f604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "956069879c8d35719bd1d8620e658280bc1ad03d8d692c533753805f6fc56d0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd421410e835f84dcb2c9d979c606c4e8f287d23808276f35db7e72d51b62573"
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
