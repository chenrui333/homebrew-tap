class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8bf45d8ad5b379cc942e4e54cbede2b3441d71dfdeb5487eeb5aa0597779d9c0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66e4c85e3e5b5f2198ffd7b00ddf2df7133ccc72ca9e52868eb70e6f2a0ef23c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66e4c85e3e5b5f2198ffd7b00ddf2df7133ccc72ca9e52868eb70e6f2a0ef23c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e4c85e3e5b5f2198ffd7b00ddf2df7133ccc72ca9e52868eb70e6f2a0ef23c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cd1b45f41da03baa780d82ed58d89f075adbdcef9ec0ef1cca79134164f9e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "728b68e23756df5212efd20cce13dfd6c5bf58a9ab8e6e0074687b6ec79810ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codespelunker --version")

    test_file = testpath/"test.txt"
    test_file.write <<~EOS
      This is a test file
      to test the code spelunker
      functionality.
    EOS

    output = shell_output("#{bin}/codespelunker --dir #{testpath} -f vimgrep test")
    assert_match "#{test_file}:1:0", output
  end
end
