class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.75.tar.gz"
  sha256 "91852112ba37fb0ecfba9be33341d065adbabad54fb3bc69b008a5ca2b3672e6"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91d7a2fb14e867722668d80a29d97c81633e234c02d0f24dfaf5ac3372563e4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b61a8c3a5e6a5f198efac1672344ac9ad3f6b59884d6e81329d627098a71570"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc83090b74c9c09d1c61e4bd2a25d655dc720ebd5698c3a0371d59c55dc0322b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7979c7fb102685a31fc5ec38c9102b15c52f6bebc72c7a673550c6e480c241e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd10aad1ea837fa9ed5bed043f1342e1f7fd4c7113668671c1008f289ea900f1"
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
