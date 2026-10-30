class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f8633bda56e1d5bd948b7d4d810da9d89cfa50cd3df53fa306d155faa18d069e"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4404737de9aaaf1fa94e303580fafc12c0f7b87e20641cf3fd24c1edffb971a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4404737de9aaaf1fa94e303580fafc12c0f7b87e20641cf3fd24c1edffb971a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da4605f7a9651a1598e996f189904eee741e0eca2019a24d6d20098794303310"
    sha256 cellar: :any,                 x86_64_linux:  "9f3d50b99000e66f976e75a776fd022dbd656292ec62dfb5938bd3818585b214"
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
