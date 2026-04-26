class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.71.tar.gz"
  sha256 "388e59024fb6130dc9be7bce4826b153d9301605700a454107623f08df00f7bf"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c8e261bd452eff14dd041fbcfcfa6f43aecaa3d42f2cc09e3a9ac57a7c219d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "687e21c7bd104941874d8e8549846e462cd09e638d6ec6d66774f751c213a0ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b482f0931639ed6aa39577c74896d93648a9bc926b5e95f5ee4dee584e3a535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff6eb0325a6f161644b831abe4898089681348f355cd0a01d0f3e85d9e13616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab120ed857062bcfc7f60895857c31e4ed4cdf875b14d6d781fad753fef7ffc3"
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
