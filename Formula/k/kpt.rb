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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87293dc83f58ea003c54841e32c9151b037040480e9a1bf678cd3dc54129ece0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb2628749a30dfb21286a4c0c9bf78f6e00664987f0ea1484a92803324b3c737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "145c28ed1fde2f76418dacc7886cb7833b0ca500ba61ab3393227114587bf9fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e88f21cb0129fa19ba611223dfd01c3701eadf10d730544d971131cce0f86346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e8996d553dc97a3129e71dcae93f668842160cb0d28cbb7b50e9ba747717af3"
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
