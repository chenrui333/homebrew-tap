class HackernewsTui < Formula
  desc "TUI to browse Hacker News"
  homepage "https://github.com/aome510/hackernews-TUI"
  url "https://github.com/aome510/hackernews-TUI/archive/refs/tags/v0.13.5.tar.gz"
  sha256 "2cb719204d92e4e2f8f86f7e666059ed0e884ee0c12fc58393bb967740a9c3f3"
  license "MIT"
  head "https://github.com/aome510/hackernews-TUI.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7233abdf4bfc70f2ba133dd184b2d3dc061e81a611cf50b58369d359cd9ad82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f800a4a46b8d9a59c13aaa403d33a53a0b0cc1129ef8bef571050d5be63a980"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ab115de1d726922731addc9dff3644e52d85679525b24b92cb7019e5c0c886"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ba0993e3973e6092401f75581f1696e2af55659bd928304f0a58ccb12cdb38b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c07ce9c86a45a0c47b6c08b026d86e0ca3abd6321724f33c421dbbe96c64c145"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "hackernews_tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hackernews_tui --version")
  end
end
