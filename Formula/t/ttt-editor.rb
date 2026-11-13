class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "bfc4d0018b90dfd503b4a15ef97dcdaf2bbaabd0112ef8df5b13d666c9286ffa"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "986538dd1790d1877b59b19e2be9d3715da3acca3d98df4cca0c13b998452dc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986538dd1790d1877b59b19e2be9d3715da3acca3d98df4cca0c13b998452dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3a80f5d9738c7ac308e8f2828b572e7f987cbbff4192cd0231a20a5e3ad584"
    sha256 cellar: :any,                 x86_64_linux:  "a0ce84dfe6d4db980425a108dfc70a6bd9995a03f5fae5ebecdf69aed4947e82"
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
