class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "485677181a8f851d3d3a745c8e6cb07f34b41a9da80f9f9323caac283dfe2d99"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "615a31cba9ff8a53e670b3c1b5ae4af441091b0cf1ed8087ed0ca72d86cf7e40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c778a5de33ad58573516c037277a080ebea233bc821c7e997f784c5ee6b3b5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb855c0ca1e9bd63551be24f917686c6ff1d2c323ed345dc2618fa29c5eae381"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb32df8d3803b33959baab0849145b301be3e71891468819a9d86e52dd8182a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf588f79fd01b05ea0fe4d8e61bfba192d53ab81b0f8ccf5686a769f374b2e2e"
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
