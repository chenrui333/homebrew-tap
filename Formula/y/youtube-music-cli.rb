class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.62.tar.gz"
  sha256 "e3d12970eef05381a23ff4582d098f5e822ad27e493e0938efb762c381b099c2"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4be6e2c0b265047c642f16a61f81c7789ef7efc2bb44447cd30d4d35584421fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a6e666abb4f4d42aef491406da26b451485c15540f54a29509f484f3f49b10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32fbc8dc5d4b472c4d6e9fa8878aa9e7cb9dae3d2ef15f22c041f1f1392eec1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2bccb72cc40288472a8a75ed81136b21864d796afcf7ed9db7b019e86b7e0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63897c48b32599a3c42be0e582dfccb2c10408951095fb3bc33932805746bc8a"
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
