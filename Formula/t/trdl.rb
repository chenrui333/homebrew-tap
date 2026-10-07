class Trdl < Formula
  desc "Deliver software updates securely from a trusted TUF repository"
  homepage "https://trdl.dev/"
  url "https://github.com/werf/trdl/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "10fbaf94ba00f687500a1e99b9b6446bea4d49135b44867a5a461c75864ba742"
  license "Apache-2.0"
  head "https://github.com/werf/trdl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "84039a40fda531784e445efae5a5deb47469416d1bafa9083cadacab0e6a83b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84039a40fda531784e445efae5a5deb47469416d1bafa9083cadacab0e6a83b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1319e2e163067e9c005fd44d28403e14eec45c0d54eab10441b9df18889e8f62"
    sha256 cellar: :any,                 x86_64_linux:  "26f50741568cda7bc1b4c4b59020c1013416d0fb99ea0046b0e68c2505f4000a"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "client" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = "-s -w -X github.com/werf/trdl/client/pkg/trdl.Version=#{version}"
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
