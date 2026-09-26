class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "b01897fa241276c5dde42742899ae3dc806172eece0a41dea21b58f05eb78cac"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f82d4b18c7dd477dfe0c6d65a9cf7d53d6de67a916abac887732e4383e4df12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f82d4b18c7dd477dfe0c6d65a9cf7d53d6de67a916abac887732e4383e4df12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11d72c1f45b0205554dd28ddfcc4860d731d226fa506846dc7457c8de1dd046f"
    sha256 cellar: :any,                 x86_64_linux:  "6c16aadc182647ef0942abafadcd07b607c7711c3c54d3c5b5d2036f5c00c59d"
  end

  depends_on "go" => :build

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
