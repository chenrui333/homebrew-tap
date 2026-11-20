class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "28022923d1ae53a72b325ad921f9cde12f5df098fa461982fca5e3e1765ce94d"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "372781f7d2afa6429b3d293bc6a7d0f2bf58a7b77916c56fd56149df28799f99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "372781f7d2afa6429b3d293bc6a7d0f2bf58a7b77916c56fd56149df28799f99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fcf103738b2e5e212e8347a5f723114a58ea28e9ae1693ad58b60f139cc2589"
    sha256 cellar: :any,                 x86_64_linux:  "2fa057788de03dd3aef53b0ddf9cc58c5c198a43a4319246e8a85e51289aefdb"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"ttt", ldflags: "-X main.version=#{version}"), "./cmd/ttt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ttt --version")
    (testpath/"input.txt").write("homebrew\n")
    system bin/"ttt", testpath/"input.txt", "--exec",
           "wait-for homebrew; screenshot #{testpath}/screen.txt; quit"
    assert_match "homebrew", (testpath/"screen.txt").read
  end
end
