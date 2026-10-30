class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "f8633bda56e1d5bd948b7d4d810da9d89cfa50cd3df53fa306d155faa18d069e"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44c958c62b4ca95c91a1307d160bd8faa20b2f939d42302a837fd0ebb87d07e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44c958c62b4ca95c91a1307d160bd8faa20b2f939d42302a837fd0ebb87d07e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8161d5572b8aa70233d33dd5b15fc2643035c12d16b9f608bd650d11c71b1ad8"
    sha256 cellar: :any,                 x86_64_linux:  "3ab85cab578cfa82668dd084ece4d789d895877b51d1e317268b20891aa8519f"
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
