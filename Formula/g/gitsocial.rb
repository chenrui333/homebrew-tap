class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f276824de15629c5640b5c2446ebc1991c50631ca73e7f505d1ea3fe0a8f1ad7"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "240fe33b62f9c5ee0a0f77d9f6e1b06a13c3656e087f0992b56df38dbcb81d3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240fe33b62f9c5ee0a0f77d9f6e1b06a13c3656e087f0992b56df38dbcb81d3b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240fe33b62f9c5ee0a0f77d9f6e1b06a13c3656e087f0992b56df38dbcb81d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4e505083f739844e5c25396ae8d0e7d746339e1e32adb85dfe58e95846144fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f62340672bb89b107a9cb41bbc01240ec697d11a5317885a0e2afd172e404364"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
