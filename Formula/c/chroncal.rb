class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "26682c871fb2a7994b20c28d0ace3a00966e2a0894a20960316f4237831801e8"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63d64f3f2b85d9ef0223b897eea5769ab091bdb042af88b301dcab2e7828802c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63d64f3f2b85d9ef0223b897eea5769ab091bdb042af88b301dcab2e7828802c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53f99b66a13ac078aeb2bb506e6659fa83e44d778fd0d7c42356f4bb49f8c79a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94e5549c300ac2205bae264b440c873c16fb9143152de6375543536ce8d3a474"
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
