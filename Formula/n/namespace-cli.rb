class NamespaceCli < Formula
  desc "Command-line interface for the Namespaces platform"
  homepage "https://github.com/namespacelabs/foundation"
  url "https://github.com/namespacelabs/foundation.git",
      tag:      "v0.0.555",
      revision: "60dfb61d104138b4c293e5384021c8982040ef65"
  license "Apache-2.0"
  head "https://github.com/namespacelabs/foundation.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4a4d379bfbf32ef8b041cda93a84bbd4e5d3556e37ac0774f6bc28894c85aa78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4d379bfbf32ef8b041cda93a84bbd4e5d3556e37ac0774f6bc28894c85aa78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4d379bfbf32ef8b041cda93a84bbd4e5d3556e37ac0774f6bc28894c85aa78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdf6a0e3d47a445da92d462a7708d2a34292c942891016563cd991162f566f73"
    sha256 cellar: :any,                 x86_64_linux:  "f2eddd47609b5694f252c63861685da93a3477fac068ad59f0d15a1ec1ef8ee7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X namespacelabs.dev/foundation/internal/cli/version.Tag=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nsc"), "./cmd/nsc"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nsc version")

    assert_match "not logged in", shell_output("#{bin}/nsc list 2>&1", 1)
    assert_match "failed to get authentication token", shell_output("#{bin}/nsc registry list 2>&1", 1)
  end
end
