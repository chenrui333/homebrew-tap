class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.65.tar.gz"
  sha256 "83e271486fb5bf9b5f04a438df024f1066e3dc1efd61f1844634c55a15123658"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c94ecf2ab2bd09b874307947d5b0712259b583738bb00f927de008910d7bbe6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57b779057443b1ecee154eabf413e227c4d57f8fbcbf3c512458c78308cafd23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eca667f155790b9a45d33a6691f2e3ae711f699d43a02ff8af9cb06a26ed9f13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5758139451cf7a5c7ec4c3be75205642c6f1f7187ffcc1e62d6583f4ceb214d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e0130861187686f62f11c0ccf9b65195543120b09b0feb9a19cd26043fc118f"
  end

  depends_on "chenrui333/tap/bun" => :build
  depends_on "mpv"
  depends_on "node"
  depends_on "yt-dlp"

  def install
    bun = Formula["chenrui333/tap/bun"].opt_bin/"bun"

    system bun, "install", "--frozen-lockfile"
    system bun, "run", "build"
    system bun, "install", "--frozen-lockfile", "--production"

    libexec.install "dist", "node_modules", "package.json"
    chmod 0755, libexec/"dist/source/cli.js"

    rm_r libexec/"node_modules/node-notifier/vendor/mac.noindex/terminal-notifier.app", force: true
    libexec.glob("node_modules/.bun/node-notifier@*/vendor/mac.noindex/terminal-notifier.app").each do |app|
      rm_r app, force: true
    end
    bin.install_symlink libexec/"dist/source/cli.js" => "youtube-music-cli"
    bin.install_symlink libexec/"dist/source/cli.js" => "ymc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/youtube-music-cli --version")
    assert_match(/plugins?/i, shell_output("#{bin}/youtube-music-cli plugins list 2>&1"))
  end
end
