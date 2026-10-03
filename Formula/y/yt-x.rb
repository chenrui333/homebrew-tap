class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "9d01bc021b31b86fa23f6349127d3a6df97d911e3f68a4f4ab5be829a1818961"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "1258aed32ba9360d615a81458c1b1672b14e560f558b80a0a3f096c467b05d3b"
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
      formula_opt_bin("ffmpeg"),
      formula_opt_bin("fzf"),
      formula_opt_bin("jq"),
      formula_opt_bin("mpv"),
      formula_opt_bin("yt-dlp"),
      "${PATH}",
    ].join(":")
    (bin/"yt-x").write_env_script(libexec/"yt-x", PATH: path)
  end

  test do
    version_output = shell_output("#{bin}/yt-x --version")
    assert_match "yt-x v#{version}", version_output

    require "open3"

    output, status = Open3.capture2e(bin/"yt-x", "--not-a-real-option")
    refute_predicate status, :success?
    assert_match "Usage: yt-x", output
  end
end
