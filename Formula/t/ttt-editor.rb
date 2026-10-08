class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "29fd1e4bc873ef5c6e07f1e357e413d186da509fa4e028c8c873a7214ce29bb1"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f792caee7d9a1f33888009d5dacc410cf232972f103ae2fc981ee616d9501620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f792caee7d9a1f33888009d5dacc410cf232972f103ae2fc981ee616d9501620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4d984dd96088843bfad82c382a874ea061ef71b863ad6cc5ea7b10a0c0f8c88"
    sha256 cellar: :any,                 x86_64_linux:  "6ba0245751d41754358bb716131868402fc1ea4bff1977d2c842dd5dce20681a"
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
