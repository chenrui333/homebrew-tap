class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.59.tar.gz"
  sha256 "77f8693eea137a97c8e66178392fef6d5a7644aaf10a06091c57e0fcd9552340"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bfd6249df123806a7c074b22b9a54b3daff8288a08a8194798711e892317499"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2cccdb764fadfb72fd89a2eb9faf211ec30dce913a98eea153645a9df44b6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86dc9f2898dbc99a28dba34b0a175038205ea7332b3fe0fec24b7f7360f59521"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d34965b86bee4f67df14845c1a9dc30b9cf8beb3de87a79bdc3d975af2ed1457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "628b45c86c5cb539275ce53744b812ddd8a368526063a908cddab87842fb5314"
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
