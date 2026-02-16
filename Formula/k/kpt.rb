class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.61.tar.gz"
  sha256 "308e809ac79c5cc72672a0119a654805ee151a94659542166194d1660f69c4c9"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33099503390306fcf88847d3a3fdc8802ed48de3965e88e1050efb313bff08f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2473b0df395a16e4d5f79f81d2177447576487a9c3f896cd7071e90fae5593e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04d857eb10f21b1b62798ec8592ca77d5f6d861f0e7e858c794a946edacb1382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dea859d77d24da64a17847c5e9c29bed5a1930f88636a32e3dc026c77b2e6f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b56b7f24de6b999746959942f07c09de0a1e972e482d240def92a8012ba205d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kptdev/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
