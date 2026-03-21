class Ymp < Formula
  desc "Browse and play YouTube audio from the terminal"
  homepage "https://github.com/trap251/ymp"
  url "https://github.com/trap251/ymp/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "da4a2c644f0b8ccc0f1aadfa7e29a6453c38bc4000d4754c8d76e2d7726246a9"
  license "MIT"
  head "https://github.com/trap251/ymp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e798008b2f2fc5640858c72578ac4a28f75b9695b88ea3e581f3c2578b3225ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31f379202e5836f828fc1a539b9507f8f2f813a3ca6d0c4403a8bc1b84f7b10a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9f831d04b99056778150fadd9fef08f0cdfcfde5b3191c253ff3990c0635d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fae0aaf19866ceab734288948bc3b4296a32ce0a075069cad6737f12997ae53f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c06e10eecec832bb7b2958ed8f5446fa2f61efe70c1cecd46dbb5a02270977e"
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
