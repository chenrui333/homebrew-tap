class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.63.tar.gz"
  sha256 "50ac6cddcdd37dbb0375cd2321f7a3dfde0bc9b80f450137eea6ebf7486f7acf"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "789e84f337bdd1b54b9f6d042d093522c4fb45142f4e6f228da412a76f390696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "009d26df7c484ec79ac954549826fececf445288e907c9ea5d377a0dcb62fc47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e42f572fd821ccacbe332b78d476f2a40abd61bb48d89dfa872df800b5770ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87e7f4d0a56093ae3c7e2906616114c0a4c93e8511a75bea6df2ee006cde2b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c193395579448ebee51a57f3f8e0a8f78bc28457ab991c07cf3feabe70cbdc2"
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
