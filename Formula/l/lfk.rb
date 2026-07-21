class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.13.tar.gz"
  sha256 "75a52b37e80eda856d29bfe87185e24a2334bd16d24d437dbdd3bcdc1722beed"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ace372fc5d020b8c73d6530a0bdfd2ba51d83f60e04204eb3d9f7d9395d9c2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ace372fc5d020b8c73d6530a0bdfd2ba51d83f60e04204eb3d9f7d9395d9c2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ace372fc5d020b8c73d6530a0bdfd2ba51d83f60e04204eb3d9f7d9395d9c2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c9fb463c6e215e7a5996b622390d7bdf1ca1ba9c5ebb12e8919b32323513962"
    sha256 cellar: :any,                 x86_64_linux:  "fe637b351412ead5f98b1decc8d14c8c6594850f61193da8ff10b3aa54b1db89"
  end

  depends_on "go" => :build

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
