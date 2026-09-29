class HackernewsTui < Formula
  desc "TUI to browse Hacker News"
  homepage "https://github.com/aome510/hackernews-TUI"
  url "https://github.com/aome510/hackernews-TUI/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "2cb719204d92e4e2f8f86f7e666059ed0e884ee0c12fc58393bb967740a9c3f3"
  license "MIT"
  head "https://github.com/aome510/hackernews-TUI.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74090564397bb88c918d09163988984f32887d206d5dc1a8419031fab8355939"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "272dc328ad6ab4c4e409f2cdd809c841acc4872040eb6e6c4a31d3bb336adc34"
    sha256 cellar: :any,                 arm64_linux:   "56bc74faf7bdac012e14712cfcb73c32d5fa8bad3a512827d6ef286af9b4327d"
    sha256 cellar: :any,                 x86_64_linux:  "f13f8f0f5631309125fb01b985a86969f5018beaf7ffcd8df0d575323bde65fd"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "hackernews_tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hackernews_tui --version")
  end
end
