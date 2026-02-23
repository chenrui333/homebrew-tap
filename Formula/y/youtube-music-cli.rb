class YoutubeMusicCli < Formula
  desc "Terminal user interface music player for YouTube Music"
  homepage "https://involvex.github.io/youtube-music-cli/"
  url "https://github.com/involvex/youtube-music-cli/archive/refs/tags/v0.0.39.tar.gz"
  sha256 "a39bb1a29af72985e508927d4d4b4ddd042c916bea3e8796873460ddfb966386"
  license "MIT"
  head "https://github.com/involvex/youtube-music-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "985e2e4c21c9e6b02ae148c674bf5e94e13cf28ed0973eb63521cd16bf5b2156"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16de173d6c423a3546f7b38fc2011a70cf4df8eaa46729337967280c2503465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88b6e38e3a6702c78f4e2fbe767e66618b9ab4ad2da64f080015f84cbb04fd0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d85f74b95dbc885987a030247490d3de3a8729e8f17a8435afb6ffc9919aff99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cbf123701dbf07de4862561c1a8eff99520beff5bd0c157e12b8fe80623acbb"
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
