class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.13.tar.gz"
  sha256 "f8d497716322a98a0609133c7f6feb94afe0185e879261f6569cf31f370d07ba"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a73997fe309f44c9b64bf1750c50ebbbce3d46610eeddffc07151ce994be5f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a73997fe309f44c9b64bf1750c50ebbbce3d46610eeddffc07151ce994be5f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66af5ec1c596ea5eab37a9c831b3225336f63dbe3abdc065aa89ce7092b2fd25"
    sha256 cellar: :any,                 x86_64_linux:  "34a025a55b3d1ad3d95303009130dc36c192c25aef4fb70515b85e4be239f95e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    output = shell_output("#{bin}/lfk not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
