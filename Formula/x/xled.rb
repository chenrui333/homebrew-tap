class Xled < Formula
  desc "Transform tabular data using regular expressions"
  homepage "https://github.com/excelano/xled"
  url "https://github.com/excelano/xled/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "4fcb5425d576db9f609ceb698915e5c3d72d2d94fe6b44f381a6f9ec18d9408b"
  license "MIT"
  head "https://github.com/excelano/xled.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcf667cb5e79f53d387839bf3b7a6dbf97dd09ff344d52d8638157bb95f3a2bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9797f47c1e2a4ae1e5011435a521cfa90dd36d437f7558127706f14e8c874b7"
    sha256 cellar: :any,                 arm64_linux:   "683559744b462a188b0f86b99ef517bb1478eb71e794b1fcaa2b8ead6088ce66"
    sha256 cellar: :any,                 x86_64_linux:  "f10d8acfe82474064200b22395af6d699b810cc430097ec202c1e36d436edb75"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xled --version")
    (testpath/"input.csv").write("name\nold\n")
    assert_equal "name\nnew\n", shell_output("#{bin}/xled '[name] s/old/new/' #{testpath}/input.csv")
  end
end
