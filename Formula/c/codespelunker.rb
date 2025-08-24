class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6553dfbfeff046d6363fbea8a46fe9ed0f145e58cca89360b84cc86f8e7cad7a"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff00ed4736af32a933cb38970d76d9bac55385d1bfdd3438fbec703762661a7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94041d324afd1ed452c6f30c0e7397824994cfad5d5c66bd1b59255a83df9ce6"
    sha256 cellar: :any_skip_relocation, ventura:       "3984fa6c86d0bde89b43685f7cec771f40c24da6930a7981d8757990109e31cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60f8ec92b22c83f8580243ad51c5ce783f21bd2888a2160d1968233544e1135e"
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
