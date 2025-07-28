class Gitmux < Formula
  desc "Git in your tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "6657fceefbee75565130ba971035610c7b71397a681fef2e58fc582b27fb5ed8"
  license "MIT"
  head "https://github.com/arl/gitmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdcfa9ec83e400ad0ecab4eddf9665606cca86cb3db881e61f76c0868a33a1cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "67af6f2f613efabad0de632a741321376c2d67538b7cdfc5555e093bf63aaf8e"
    sha256 cellar: :any_skip_relocation, ventura:       "8c5481ecd3f50828ed06a2f65efe74c3a0dc157ecf76938aecedb3b3f85fb096"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c99d9b6a7345a328b32665211bb0d000a472b2a6da91fb859948e1e5215942"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match "gitmux #{version}", shell_output("#{bin}/gitmux --help")

    assert_match "tmux", shell_output("#{bin}/gitmux -printcfg")
  end
end
