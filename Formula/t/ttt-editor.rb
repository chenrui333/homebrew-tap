class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "f7af3bdf057a6e872071e9687ffe139fbdfb0ec17dd1d328ede7da559ce42470"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "e6f5fb4143fff4ffee857ab7a7a34e23d03a219b2fe2152c44dd0b45a1985206"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ff25a066e66899a43ad66551fe6c950c69088269b686597510c14d0fa1ed1ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ff25a066e66899a43ad66551fe6c950c69088269b686597510c14d0fa1ed1ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d997d8259c2ee35d1889158bd0b460dc0dc011e5ac47121a9fb43d6e4deff9"
    sha256 cellar: :any,                 x86_64_linux:  "dd03c3d5c54518fbc19d3b41a1b87e55a9b14831e99add450cab5f3c4ced5e09"
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
