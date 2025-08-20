class Hyperbolic < Formula
  desc "Command-line interface for creating and managing GPU instances on Hyperbolic"
  homepage "https://github.com/HyperbolicLabs/hyperbolic-cli"
  url "https://github.com/HyperbolicLabs/hyperbolic-cli/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "c6c88cbd0f48d67df9688a50b59b13fc3bd6b24cd4274e142f63d7fd1d8b7928"
  license "MIT"
  head "https://github.com/HyperbolicLabs/hyperbolic-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07d4c1ba271d80449a25d75c2295ae6904a3ec05f814406478d488a07307015a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "256d55ef6c1eb1ca9b24e4cfe5a121e2ec3c672c755ef0fcd2687b201f8e59d4"
    sha256 cellar: :any_skip_relocation, ventura:       "347bbb11a0c9e3a8d3d79274bf14b2e320fe471eba537f16e3e00b2a8e94b4c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48852823a72aa3af4376d49eb00e04c12a3518226f2110fa6cdf831a581ca807"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "hyperbolic", shell_output("#{bin}/hyperbolic --help")

    assert_path_exists bin/"hyperbolic"
    assert_predicate bin/"hyperbolic", :executable?
  end
end
