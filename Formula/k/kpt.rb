class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.68.tar.gz"
  sha256 "2323193feeb8a225d4cc00193d68ed24e92c13e3bd3bf601d598fadb481617c0"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3214a36b47f84fe0be74a84083c54e04fd6c4ca252937f243a774072aa4dc734"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ebc04a115d70f30f1c7094ffdcac619db2d66b29ed7ea21d6f360fb815503e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a984f5d9e8a121470528d978aef7c41647d392c69c4ab91fdaee62a67760dfb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38db837c22e38ad16e5a429c071330c5264011bccdf210bbc0f5f043f3bb726a"
    sha256 cellar: :any,                 x86_64_linux:  "c35e0e0fd31c92ce148013901137535a39d0c17b122c5aad50fbe972729a3e33"
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
