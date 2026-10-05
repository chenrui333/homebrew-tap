class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "8ae07f9608227fa4b12a775fb2f47650f6e73f62d7de1e3bc5482097ab52b1d5"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0353f724e24481fa60b7876eb8ba007f5fc4637f5c3e20b538bf90ad9b6970f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0353f724e24481fa60b7876eb8ba007f5fc4637f5c3e20b538bf90ad9b6970f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2775d549dd2a8a4d819571de956e8aee98413e8094b2a04491286141800c7c2d"
    sha256 cellar: :any,                 x86_64_linux:  "12af4026f03deaa4e3a028df4f3f2556ef1b8474a8c17969be38af15d5f8fa2d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"ttt", ldflags: "-s -w -X main.version=#{version}"), "./cmd/ttt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttt --version")
    (testpath/"input.txt").write("homebrew\n")
    system bin/"ttt", testpath/"input.txt", "--exec",
           "wait-for homebrew; screenshot #{testpath}/screen.txt; quit"
    assert_match "homebrew", (testpath/"screen.txt").read
  end
end
