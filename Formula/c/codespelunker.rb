class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "b6212838289a634f9ee1bfeea33cdbfbb4c5a291f780c01bddd3054d48b32ac0"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29f7708381b2a3f57eff80597055110c2adf4350d1e81ce4ffa4a5824f00a766"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29f7708381b2a3f57eff80597055110c2adf4350d1e81ce4ffa4a5824f00a766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29f7708381b2a3f57eff80597055110c2adf4350d1e81ce4ffa4a5824f00a766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "274f675e040ca077b5028170e2d2fd82579e42504249fa7cbde5eaaedcccb86d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7d8d42b50a27f5da05e561baf5a442fadd0c262b84f1307ef2975783978e087"
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
