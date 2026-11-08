class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "1fd69a36fd79df9ed935180b07f1499785abfc64aabf3aef8171c0e1c7933e53"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da98c0de6b672922016e8279e39d950eed841c0be2042b1697167e1dee590490"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da98c0de6b672922016e8279e39d950eed841c0be2042b1697167e1dee590490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f55fa718c3e68c7fd1e34123a90543072723b0d88c38f2f768af9574fee99a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "468bca69f3c6142731ac244f47c106d82823f8320c28f4fe7351266c344a392e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/chroncal"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chroncal version")

    ENV["CHRONCAL_DB"] = testpath/"chroncal.db"
    assert_equal "[]\n", shell_output("#{bin}/chroncal todo list --output json")
  end
end
