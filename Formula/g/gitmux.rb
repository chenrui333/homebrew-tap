class Gitmux < Formula
  desc "Git in your tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.5.tar.gz"
  sha256 "c6a01faa5372a8c4ab24bc3a2c9665a9f430c45c79b175c1510388433637ca72"
  license "MIT"
  head "https://github.com/arl/gitmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c571e1f7a1fe2166299ea65413a7f2bbfafeec95f3f0996fb733a9512ccae156"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "846d0fbfb539f9c6cf87b7fd65e0d7c470aa884f5cd79aad185dcc4635961269"
    sha256 cellar: :any_skip_relocation, ventura:       "249bbfed44545ca1c21cdc5cd92e66e9d52313d2a4a7169395615fa17eb62ce9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4088a33689dd964b0f75e09a1a2826ee52baa573255bab4cf3496d4fd1538c5e"
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
