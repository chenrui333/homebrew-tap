class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "3c4c075d805c99a4fac0196c31ab770d9446852a5f328b6ced23514af46818d0"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6280219a05c263d37eb9bfe3dca58a3e640025c96bf9f3c39d3ba24b3b4f1fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22bc7acc7fb5c68942e72aeeac9d03d1b7bbc615a8e4e4918b64dbc7e9ff1425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bce8de94ec8f73411202787ea173bfe852a1d6695b258d0ed20bd9b3a2c83f37"
    sha256 cellar: :any,                 x86_64_linux:  "7a684491655d4ca1862e5ce58080df831ae6957a0abf0098f9121995e1ce2e7b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
