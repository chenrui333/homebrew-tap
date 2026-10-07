class Ymp < Formula
  desc "Browse and play YouTube audio from the terminal"
  homepage "https://github.com/trap251/ymp"
  url "https://github.com/trap251/ymp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "da4a2c644f0b8ccc0f1aadfa7e29a6453c38bc4000d4754c8d76e2d7726246a9"
  license "MIT"
  head "https://github.com/trap251/ymp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a7c788be7f45b7969672cf1ad673b0e33b8aab8547e2297843d2e8006d5e68e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4e7d687a5dc8d492ccb57e338c56c2c090a3d47905154b45f5cb3b5241fa92"
    sha256 cellar: :any,                 arm64_linux:   "b133d65b33030f34fdb633740c25e68de8455a7e5d1f4d5c158c55ccd2f8b59d"
    sha256 cellar: :any,                 x86_64_linux:  "4b50ecb213222a5950326a128b45d47ce8994b8b7bf9bee40da0bba2bcb56e37"
  end

  depends_on "rust" => :build
  depends_on "mpv"
  depends_on "yt-dlp"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
