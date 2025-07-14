class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "03066f806b02f0565a1c99f2dfe98423824f48b285e0850dc3de4e4dc1aeccc5"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38d26b7f1ac06d0e0a1bfe76b78d32f5dd325289f9efaa11b4e895aa98856719"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ddd31a605dcbbc84a85c45944f7097dbb70b46c39568df715bc995be22adedc"
    sha256 cellar: :any_skip_relocation, ventura:       "46e7bd9a084761947a343aa2483015ced66f63ffe2244ef6556351b9e2324b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eae3c383eb29f67f94781555271d4e9f5f2a14b78f24a8a6e65660ad097d3874"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
