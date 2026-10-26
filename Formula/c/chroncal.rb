class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "82b26f89cd4117e8280600461905b0e0dc4120c2561e5bec58594f8c1e9f59c9"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fafc58445df29a5557464c7d9339316ba4ac24240f20153795db215183d49dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fafc58445df29a5557464c7d9339316ba4ac24240f20153795db215183d49dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e82b35e38281aeb3652c87b3e24f484e97ca5f69b74e1e87cc5196694492f190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e5238ac4f5beac8c9f6d8d7cadedd32913fd3917ee7d735ecdb6c7f4311ef3d"
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
