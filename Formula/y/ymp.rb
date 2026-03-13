class Ymp < Formula
  desc "Browse and play YouTube audio from the terminal"
  homepage "https://github.com/trap251/ymp"
  url "https://github.com/trap251/ymp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6cdd43fd0b058745b37d34dfb7a7427e83a8d0ccfb3978f412095f9805cbbf4a"
  license "MIT"
  head "https://github.com/trap251/ymp.git", branch: "main"

  depends_on "rust" => :build
  depends_on "mpv"
  depends_on "yt-dlp"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TERM"] = "xterm-256color"

    cmd = if OS.mac?
      "printf 'q' | script -q /dev/null #{bin}/ymp"
    else
      "printf 'q' | script -q -c '#{bin}/ymp' /dev/null"
    end

    output = shell_output(cmd)
    assert_match(/\e\[\?1049h/, output)
    assert_match(/\e\[\?1049l/, output)
  end
end
