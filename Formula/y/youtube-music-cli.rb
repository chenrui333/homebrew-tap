class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.67.tar.gz"
  sha256 "79c85c42af0c86a9825cabf169f2d0892ec0808ee5f2e0bcb7bed568be1e47bd"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61558062c3cf3399d4f4489933d8e43d033027b31c5170266d68d072644f384d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f80f11eafda468d4a4beb8afc5b9df6afb63baca291c6864f103b1c3e84b141d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8092b76ebaa750c463ed544404a5168765af3661bd739bd09f56753594926389"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ff23979e52038a56c2c2461f8f0eaf723d0112a0028b80ce191316b119c7b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c311a617d8efc79ea83d803539f2fe435c99322e475018c7e1843a52a3a75a5b"
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
