class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "7b54f1612db87c50de279e36b5cdc646e086fa3499aba9db2dbecc3e6faa6a39"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fec29e0a4731e7c3cf39d317957910ffd95b1d45c2078e0a1d79ec070b950e1d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fec29e0a4731e7c3cf39d317957910ffd95b1d45c2078e0a1d79ec070b950e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "883ea3bc522479d96fe16f56fc1fdea759e4700022139a915a32fec7f3233b29"
    sha256 cellar: :any,                 x86_64_linux:  "cf203e34e282a4b240cace5ebea2c1a3b68aa25265abc7de142a65a7bccd781d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "client" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = "-X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
    cd "client" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/trdl"
    end
  end

  test do
    ENV["TRDL_DEBUG"] = "true"
    ENV["TRDL_HOME_DIR"] = testpath.to_s

    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    output = shell_output("#{bin}/trdl list")
    assert_match "Name", output
    assert_match "Default Channel", output
  end
end
