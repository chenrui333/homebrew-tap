class Kpt < Formula
  desc "Automate Kubernetes Configuration Editing"
  homepage "https://kpt.dev/"
  url "https://github.com/kptdev/kpt/archive/refs/tags/v1.0.0-beta.64.tar.gz"
  sha256 "f8512c838d7ab955abcf27f14293c63da5e4aefa9efe5647f7cd91e24831906f"
  license "Apache-2.0"
  head "https://github.com/kptdev/kpt.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-beta\.\d+)?)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb5d83e00f73c256332b8765f96b9b61807ac275e8f1085d3459f271ec050be2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b966fdf3802447f402525baca765c216acc8efe36b658b147aa2957b86350d56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30bc62e6bc0fea1171aec07b366c8988fb358f6827f8a7ebf8668a81c7f6223b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fa00f1f4f8448389fa4dd92cf2a3b3961c6ec3cfb4856a1bed812525c9d36c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125b70eeef2c60afe7d3000af84e6f1a5210a0e7e53929aee514df55904bd1dc"
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
