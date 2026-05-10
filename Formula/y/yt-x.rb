class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "6fc7ec5cde80ed6236a6864390e68d3c0abd654709928eb57dceaac2984f6e61"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "67143502e7fca4dfa44e049963721608fc2b2e94ef2f2f967a38b40e43fab63e"
  end

  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", /^CLI_VERSION=.*/, %Q(CLI_VERSION="#{version}")

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

    old_extension_dispatch = [
      "    -x | --extensions)",
      "      [ -n \"$2\" ] || _app_usage 1",
      "      if [ \"\${2#/}\" != \"$2\" ]; then",
      "        . \"$2\"",
      "      else",
      "        . \"$CLI_EXTENSIONS_DIR/$2\"",
      "      fi",
      "",
      "      shift_count=2",
      "    ;;",
      "",
    ].join("\n")
    new_extension_dispatch = [
      "    -x | --extensions)",
      "      [ -n \"$2\" ] || _app_usage 1",
      "      if [ \"\${2#/}\" != \"$2\" ]; then",
      "        . \"$2\"",
      "      elif [ -s \"$CLI_EXTENSIONS_DIR/$2\" ]; then",
      "        . \"$CLI_EXTENSIONS_DIR/$2\"",
      "      elif [ -s \"$CLI_BUNDLED_EXTENSIONS_DIR/$2\" ]; then",
      "        . \"$CLI_BUNDLED_EXTENSIONS_DIR/$2\"",
      "      else",
      "        echo \"Extension '$2' not found in $CLI_EXTENSIONS_DIR or $CLI_BUNDLED_EXTENSIONS_DIR\" >&2",
      "        exit 1",
      "      fi",
      "",
      "      shift_count=2",
      "    ;;",
      "",
    ].join("\n")
    inreplace "yt-x", old_extension_dispatch, new_extension_dispatch

    inreplace "yt-x",
              'ext_dir="$HOME/.config/$CLI_NAME/extensions"',
              "ext_dir=\"#{pkgshare}/extensions\""

    libexec.install "yt-x"
    pkgshare.install "extensions"

    with_env("HOME" => buildpath.to_s) do
      generate_completions_from_executable(libexec/"yt-x", "completions", shell_parameter_format: :flag)
    end

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
    require "open3"

    env = {
      "HOME"            => testpath.to_s,
      "XDG_CACHE_HOME"  => (testpath/"cache").to_s,
      "XDG_CONFIG_HOME" => (testpath/"config").to_s,
    }

    desktop_entry, status = Open3.capture2e(env, bin/"yt-x", "--generate-desktop-entry", stdin_data: "\n")
    assert_predicate status, :success?
    assert_match "[Desktop Entry]", desktop_entry
    assert_match "Name=yt-x", desktop_entry
    assert_match "Version=#{version}", desktop_entry

    assert_path_exists testpath/".config/yt-x/config"
    assert_path_exists testpath/"Videos/yt-x"

    fish_completion, status = Open3.capture2e(env, bin/"yt-x", "completions", "--fish")
    assert_predicate status, :success?
    assert_match "complete -c yt-x", fish_completion

    version_output, status = Open3.capture2e(env, bin/"yt-x", "--version")
    assert_predicate status, :success?
    assert_match "yt-x v#{version}", version_output
  end
end
