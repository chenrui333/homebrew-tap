class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "bfc4d0018b90dfd503b4a15ef97dcdaf2bbaabd0112ef8df5b13d666c9286ffa"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccd8e104247acb48a1dde8d8fc85b2e9d82ed940222a4b49b94c590cdf947e3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccd8e104247acb48a1dde8d8fc85b2e9d82ed940222a4b49b94c590cdf947e3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d6cad3f0921e4014411cfeb0467ee23f89412d58833ac94a90ef5d0e2e673f9"
    sha256 cellar: :any,                 x86_64_linux:  "62a4c09e3315bea7837215faa834596ba3047ad689e0447385f45e695aad3543"
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
