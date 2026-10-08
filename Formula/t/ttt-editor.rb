class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "29fd1e4bc873ef5c6e07f1e357e413d186da509fa4e028c8c873a7214ce29bb1"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c5928279ac266a8251bc0dcf499ec9a0f4b427cc07df6e3781a3b11ab3eecbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5928279ac266a8251bc0dcf499ec9a0f4b427cc07df6e3781a3b11ab3eecbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5133ff8997880dcb90f33df0fe85527c0745fec8bb0612b344f0bfa36a6f92d7"
    sha256 cellar: :any,                 x86_64_linux:  "ada928225ec48b00ec32ac628723a42b24227adbef5c7587ca09785b60f6b8dd"
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
