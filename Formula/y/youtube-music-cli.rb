class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.62.tar.gz"
  sha256 "e3d12970eef05381a23ff4582d098f5e822ad27e493e0938efb762c381b099c2"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d651ccb408f04a7968f53d1c55eee35588a08691d058fb5adb25b272763781b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a22bcd7897aa9cc65cf0e2ec43a19ac2195db6a9079f146162d02aeae697d37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20b71b805b1058d157ba6caa5ef0f54d7da22a4440c11e7cc5b4504efe7c3039"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "622a4b041d8b79a1870663e7353551366a914209bd68d1317a281aef9ae19955"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2faecbf89aaf45087a7733af645a5534e7294a78700e6af36ee8dc59b0c7559"
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
