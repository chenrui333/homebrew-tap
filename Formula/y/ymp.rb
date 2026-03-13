class Ymp < Formula
  desc "Browse and play YouTube audio from the terminal"
  homepage "https://github.com/trap251/ymp"
  url "https://github.com/trap251/ymp/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6cdd43fd0b058745b37d34dfb7a7427e83a8d0ccfb3978f412095f9805cbbf4a"
  license "MIT"
  head "https://github.com/trap251/ymp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48d67de63c48ca5667bf619ff657fd5cb6f7f13f9a079e21e5769cacbd57b71b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f26d7aee3e9d8d7c7b39734de02d5c7bd98adedad534d262a7ad356165137aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e57578bdd926f84457676d163fd63020e7b2a235a66d663c79a6a5e21af3a2e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a23cae0a9f8e7d20bd800fd3b2e3ce664d7e06ce985b985b2764bb643e70b6dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee2fe9e55b494a414539840963391167c7785910bd31c9e74631dc2424dd16b"
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
