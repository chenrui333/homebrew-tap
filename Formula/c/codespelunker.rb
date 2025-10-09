class Codespelunker < Formula
  desc "Command-line codespelunker or code search"
  homepage "https://github.com/boyter/cs"
  url "https://github.com/boyter/cs/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "6553dfbfeff046d6363fbea8a46fe9ed0f145e58cca89360b84cc86f8e7cad7a"
  license any_of: ["MIT", "Unlicense"]
  revision 1
  head "https://github.com/boyter/cs.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58fa01b9359921bdc36877bf18abccbd1b6ea1667220697c23a2e32f552d80fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58fa01b9359921bdc36877bf18abccbd1b6ea1667220697c23a2e32f552d80fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58fa01b9359921bdc36877bf18abccbd1b6ea1667220697c23a2e32f552d80fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25609ac95f0ed1b0956be103e7ce5cd7c2f2504ddf15d32fe13d3e0187ae53c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd0507af86aa1be71a6ca0090c3dde423200a277f71cb5262c17a0d884ab4a5e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
