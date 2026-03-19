class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.58.tar.gz"
  sha256 "8e73c93ed8ef7257d40b647be4104cdf3ccc50d2cb2edc54f38038c8a0594933"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59a85c8ef1a503c15c74d6e09a2dd2af9ebed546eef4ad3f3f6d271bcb8bb3b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e042b1eb11b48e42e8762cefcda0fe9dee7592289acac91d3c58b77ceac706"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff6cbc810b19ac6446088cf1b08fcbe85709105c9fbf449038b20a6ed12ae047"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e2903c91f6d77f725de450d86a0ff92fd0e4d5067b09b4d2dccc64764d7b2ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade17060532599fe83c84794eace16d6fd83ddbaae6c3a17ce308dccf7e5ce47"
  end

  depends_on "chenrui333/tap/bun" => :build
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
