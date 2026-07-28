class Hulak < Formula
  desc "Lightweight file-based API client with encrypted secrets store"
  homepage "https://github.com/xaaha/hulak"
  url "https://github.com/xaaha/hulak/archive/refs/tags/v0.3.31.tar.gz"
  sha256 "f0e4facef1307c4c6bfb73cf249751991a04e513885384d35cfa78d82c2fd6a3"
  license "MIT"
  head "https://github.com/xaaha/hulak.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7159ba63f8c15830317d1f92e633d0096c29bcf61a7360cbcba6dd75401bd3c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7159ba63f8c15830317d1f92e633d0096c29bcf61a7360cbcba6dd75401bd3c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7159ba63f8c15830317d1f92e633d0096c29bcf61a7360cbcba6dd75401bd3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f13c3c454943da031ab107bfe69d8987b28417d73a7e6aa1b3360c6347a872"
    sha256 cellar: :any,                 x86_64_linux:  "fe1f64d02f66000c7fdeb411128372660316375345d846492d54625b1739729e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/xaaha/hulak/pkg/userFlags.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hulak version")
    assert_match "Initialize a hulak project", shell_output("#{bin}/hulak help")
  end
end
