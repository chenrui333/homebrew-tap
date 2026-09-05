class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "334bfa273fd57af06324f30e7447306c93b03d7146ddbc2aae8b63dd52b6fc4e"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19aaf0deacd7cb8448d984b8afb646a6020d6689fe9e1e730349f5e04587b62d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "788c64946298303c83a8382890af67a7ff15eda8ccc8e480845ffb1dec353cbf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bcf7d2b9d324231d27adfef145d414907ab9108d21138a288496b2f9fdeb9a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10776850a9e981a4ad9f6831b62aa0370de52ca417cc18dacbf3e87b61a0764d"
    sha256 cellar: :any,                 x86_64_linux:  "03eb0e4c28c1f517e3dea94f1b04801bd4c2f7ff6469cf2ea78edddf82b7d758"
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
