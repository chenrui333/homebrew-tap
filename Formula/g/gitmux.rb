class Gitmux < Formula
  desc "Git in your tmux status bar"
  homepage "https://github.com/arl/gitmux"
  url "https://github.com/arl/gitmux/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "c62b180415c272743d01531b911091b9c35911be4ec4aae3e7bfceddf5094f6c"
  license "MIT"
  head "https://github.com/arl/gitmux.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3904c2c16c1e9e336be608d92659457a5e64a2cc41ee12c6f13d4ba763bd797"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa7d73fd8e126b3f974f3fecc79987dd30ec448f2690cc542a79e8f461ad9f9"
    sha256 cellar: :any_skip_relocation, ventura:       "ecd846c151fbed6791ea4a6ea822c58cef1929a1b897fc8b1cc3e58734372f12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3d405a9a546b5c8a101845f992610c77433b617bf0e231c051c6b6bffa40c0e"
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
