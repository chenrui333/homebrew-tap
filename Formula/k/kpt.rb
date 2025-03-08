class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.56.tar.gz"
  sha256 "e5fb5a2b06c4f9e49676cfcc292be42b787c3607f75a3cf3050e829803e68c1f"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/GoogleContainerTools/kpt/run.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kpt", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kpt version")

    output = shell_output("#{bin}/kpt live status 2>&1", 1)
    assert_match "error: no ResourceGroup object was provided", output
  end
end
