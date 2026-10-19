class Chroncal < Formula
  desc "Terminal-first calendar, todo, and journal manager"
  homepage "https://github.com/DouglasdeMoura/chroncal"
  url "https://github.com/DouglasdeMoura/chroncal/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a6bec5cfa5a9a42b716c6d1633e715d2b9450ca731ca67ad3ef0e8c206c023ca"
  license "MIT"
  head "https://github.com/DouglasdeMoura/chroncal.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5799c9a9b9f8c0ec9c24bf7aca6e0db43be11edeab7578d2cc625d18ede29e77"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5799c9a9b9f8c0ec9c24bf7aca6e0db43be11edeab7578d2cc625d18ede29e77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b555b3937219121b2a68d09261800e99d1e9eafe4e0d3d0a02cbcdd4bcb314c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28f4ddaf5f517d9a4b0d1bb86b1c7aeca0680bbd8b4eb42ce2d37008e96dddf9"
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
