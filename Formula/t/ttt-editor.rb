class TttEditor < Formula
  desc "Terminal editor with LSP and Git integration"
  homepage "https://github.com/eugenioenko/ttt"
  url "https://github.com/eugenioenko/ttt/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "e4bbc7e8e4e156005fd5148e3a58d741f3a180393c9dcf764d2be063f4eaf2b9"
  license "MIT"
  head "https://github.com/eugenioenko/ttt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "969065d32201f0867bf231a6e30efe84eb313a5ac743b8ac0395e183fe4e9a65"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "969065d32201f0867bf231a6e30efe84eb313a5ac743b8ac0395e183fe4e9a65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "952acfc7ce5e4f2464d5f2e911823b2caceca7b93edcd918b83864b518fe4779"
    sha256 cellar: :any,                 x86_64_linux:  "b0a798b627e877b8526a1d24662097d302509c92bc58df436730523ba58cfaa7"
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
