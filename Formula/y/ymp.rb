class Ymp < Formula
  desc "Browse and play YouTube audio from the terminal"
  homepage "https://github.com/trap251/ymp"
  url "https://github.com/trap251/ymp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "da4a2c644f0b8ccc0f1aadfa7e29a6453c38bc4000d4754c8d76e2d7726246a9"
  license "MIT"
  head "https://github.com/trap251/ymp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fdb25bcdd9db5235fdd0febc4594cdab8a0d451d958db4f1345595612886940"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "457a1b1aab0889d1033d8b6224caaf1023dea98286c8d251e2345865d41135c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041b54be227ad7017a002bcc96e5449b67d0d8c473cc443b1d6fe281be7d21ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d43539d589d4b4b56138ded42b30a7c66a4f47430b185a3f912e889871bd0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "453dda4074b4a123229c0e806b91b83f1978c349fbf7f003220e95f8d34c83e5"
  end

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
