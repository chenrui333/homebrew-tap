class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "7c8cb466f9828f72acf648f94ca685a6629a52241dc732c8a19c3d8b0b4cecc7"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10fa56eb38a0c484e4c4919355be831f2a89b617eaef09de1d104402118d0b53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1ff697ebf4cbd755d6e142ff7b19f991b018287b11455a52bd4a283cc80a217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "212abc4d6782872e4e242551b954040fc81f71bd65bab425f8e62645ac864c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "541dadc9117a3d5ede5708842cebb394220aceb6f2e0c0e73e4087023ebf1d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e64af2228fdeec78681a6d1cf7a869d419e19f84e5133e2679b98dfddb369c9"
  end

  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    system "npm", "install", "--include=dev", "--legacy-peer-deps",
           *std_npm_args(prefix: false, ignore_scripts: false)
    system "npm", "exec", "--", "tsc"
    system "npm", "install", *std_npm_args

    notifier_app = "lib/node_modules/@involvex/youtube-music-cli/node_modules/" \
                   "node-notifier/vendor/mac.noindex/terminal-notifier.app"
    rm_r libexec/notifier_app, force: true
    bin.install_symlink libexec/"bin/youtube-music-cli"
    bin.install_symlink libexec/"bin/ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match "No plugins installed.", shell_output("#{bin}/youtube-music-cli plugins list")
  end
end
