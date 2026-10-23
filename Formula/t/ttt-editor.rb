class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "87b7623f5b02f1a7a549e7c33150740e7406b069124b7e48327c23c4586ec353"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e90a184adb34ff340b4db76bff65485f44f4c10260d76cd699d89cd74a6ae163"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e90a184adb34ff340b4db76bff65485f44f4c10260d76cd699d89cd74a6ae163"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b5424af3982f802ad878beb1c731572f6b697c04ba59062077f8b37ef0dc18"
    sha256 cellar: :any,                 x86_64_linux:  "cd20fd39750a6ed59545fa7a45bb55e548e095afee6cf7e7ac30b78dbbae6a0c"
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
