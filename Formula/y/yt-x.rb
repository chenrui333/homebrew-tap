class YtX < Formula
  desc "Browse YouTube from the terminal"
  homepage "https://github.com/Benexl/yt-x"
  url "https://github.com/Benexl/yt-x/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "74fd001e240356286feae33052c00bb67ac2355017b674e012f1bab7496108d5"
  license "MIT"
  head "https://github.com/Benexl/yt-x.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "9acabed0ff42e4b8ac2c63e93fef357fe0c93c3efe81949f9acfd0b5083374a7"
  end

  depends_on "ffmpeg"
  depends_on "fzf"
  depends_on "jq"
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    inreplace "yt-x", /^readonly CLI_VERSION=.*/, %Q(readonly CLI_VERSION="#{version}")

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
    assert_match "yt-x v#{version}", shell_output("#{bin}/yt-x --version")
    assert_match "--generate-desktop-entry", shell_output("#{bin}/yt-x --help")
  end
end
