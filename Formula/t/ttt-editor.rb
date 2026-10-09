class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "42006ddbdd2721ffa555a4609e80859b2388058b7a72b09710009b6300b2a017"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "68697d0faa9dabb0ab2192acf1e1aed40af31f918080a0c048348669db0c2437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68697d0faa9dabb0ab2192acf1e1aed40af31f918080a0c048348669db0c2437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295dedc298d9071df89f2ff43e3697938b371aa4954c7c6b006a063f7cb6770a"
    sha256 cellar: :any,                 x86_64_linux:  "ec89a9256edbee87b1c2966ef9d0f29b11faf729c55791adc9b879365a948963"
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
