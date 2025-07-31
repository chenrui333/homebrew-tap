class Gitmux < Formula
  desc "Git in your tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "c6a01faa5372a8c4ab24bc3a2c9665a9f430c45c79b175c1510388433637ca72"
  license "MIT"
  head "https://github.com/arl/gitmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ed9d9b7eb4467aef1a02e13f93ec4c1e4071d7d82422a24810237c5d6bb0cad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b036a4d61b217710a939fbfe48e1617da950ccb8760cd39c607df086177e7d61"
    sha256 cellar: :any_skip_relocation, ventura:       "d17e5ef7de46c2f06b95cd4d2a2c69212f2799287cb2017fca29a1168f9b91be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b9f939a397798aa61db05d10a3ff8447223a59a11547b9eb67b73c5016d9ca"
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
