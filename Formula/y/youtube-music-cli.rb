class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.57.tar.gz"
  sha256 "00f2cdcfbe8b8c248b0bc1a9f5717301f2f85f4fe2c428d1ef934fdd38e48617"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea72cea8e7a96c91c5213b9424703425c62a69fa95091196086eff6a56a099e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bfcbf86060af8a649d7d442d0bffb52568ebe55bbcfb52a305a1f7ac1c8b75b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bda36b76ca99c6e5f1ec56b08f8d4117128a799eebe2264217b21d2986a1d672"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "251a2693b05db153a7a6145d92b1d1e4f54174fbf4e6538c1ecfb04b5339e0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5e0d07498ce86bb364191fe024bbcc5e0e695f8ba759528e195e7155b715eed"
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
