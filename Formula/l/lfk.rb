class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.17.tar.gz"
  sha256 "23f92bbb405951a6cab8f6ec1d5920eaa9e5c5e731f6f04a955abdd3cb210f5d"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5641cb8232c57630d5889baeea4547043487b032578cf9e53d38b14bffcb6db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5641cb8232c57630d5889baeea4547043487b032578cf9e53d38b14bffcb6db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07b37f9fc6a034242b31182ab069e282fc6f761584dd04b9db5c2a139d614578"
    sha256 cellar: :any,                 x86_64_linux:  "fe97bfdc14a478da09795fbda3010440f75698202385c9f3f1e947bb34021f1e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
