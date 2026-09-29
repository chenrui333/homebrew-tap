class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "7590e5065f7bc1b4bbbac8086ae2fba97eacb84c7ff0d9b48203fa188b38132b"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "233bdc6210df90237af0c831ae791849454d9393cc5930aa4d4b85eb75434657"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "233bdc6210df90237af0c831ae791849454d9393cc5930aa4d4b85eb75434657"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8989d546b6a23e412d24c3bca5f586eee98991643fddaf6dfeb064b39919829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8e26c7e959ecd01f8cfb96f68529205be51a05bfb31000862b5a0a4412bfca8"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/chroncal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chroncal version")

    ENV["CHRONCAL_DB"] = testpath/"chroncal.db"
    assert_equal "[]\n", shell_output("#{bin}/chroncal todo list --output json")
  end
end
