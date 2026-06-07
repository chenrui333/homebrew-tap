class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "292f4eca4d8f321cb9f98c1999cc9f154dee61d7cc7fd8aa6b11c38a0505e75c"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "58b28b4ff2e2eddcce15a598977937e3e2e518c3c0e5c533bb262e96c1fa4c98"
  end

  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", /^readonly CLI_VERSION=.*/, %Q(readonly CLI_VERSION="#{version}")

    inreplace "yt-x",
              'CLI_EXTENSIONS_DIR="$CLI_CONFIG_DIR/extensions"',
              <<~EOS.chomp
                CLI_EXTENSIONS_DIR="$CLI_CONFIG_DIR/extensions"
                CLI_BUNDLED_EXTENSIONS_DIR="#{pkgshare}/extensions"
              EOS

    inreplace "yt-x",
              '[ -s "$CLI_EXTENSIONS_DIR/$ext" ] && . "$CLI_EXTENSIONS_DIR/$ext"',
              <<~EOS.chomp
                if [ -s "$CLI_EXTENSIONS_DIR/$ext" ]; then
                  . "$CLI_EXTENSIONS_DIR/$ext"
                elif [ -s "$CLI_BUNDLED_EXTENSIONS_DIR/$ext" ]; then
                  . "$CLI_BUNDLED_EXTENSIONS_DIR/$ext"
                fi
              EOS

    inreplace "yt-x",
              'ext_dir="$HOME/.config/$CLI_NAME/extensions"',
              "ext_dir=\"#{pkgshare}/extensions\""

    libexec.install "yt-x"
    pkgshare.install "extensions"

    path = [
      Formula["ffmpeg"].opt_bin,
      Formula["fzf"].opt_bin,
      Formula["jq"].opt_bin,
      Formula["mpv"].opt_bin,
      Formula["yt-dlp"].opt_bin,
      "${PATH}",
    ].join(":")
    (bin/"yt-x").write_env_script(libexec/"yt-x", PATH: path)
  end

  test do
    version_output = shell_output("#{bin}/yt-x --version")
    assert_match "yt-x v#{version}", version_output

    help_output = shell_output("#{bin}/yt-x --help")
    assert_match "browse YouTube", help_output
  end
end
