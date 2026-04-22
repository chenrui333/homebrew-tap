class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.71.tar.gz"
  sha256 "388e59024fb6130dc9be7bce4826b153d9301605700a454107623f08df00f7bf"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e24a40dbe2b7f283a99a4b69bb0911643f80d0589fa7baa487208daa236acfb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e8ad75b3834bfa87e5784141e0701b3ad17ef963cd57d66870537d0dc81b8c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38a331bde7a9d4a0688fcf3055351d7ac46919d89abc2c295addc3d369431448"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcdc4356eba2ff3525b9b2f903182911ba92ad4e441001a45bfca348c49fbe69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c48539983a00dd8c74205553e2fd30f21b85d036d022970a11ed74f8207d4684"
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
