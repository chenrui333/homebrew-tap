class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "b01d8aa7dc64d17e261ce4d31d92aea1fefd69a0793c906d4ea1180ff78c28cb"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

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
