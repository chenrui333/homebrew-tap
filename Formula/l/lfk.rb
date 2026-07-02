class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.19.tar.gz"
  sha256 "4f46a72402305e16ef2ed2bdb5c2be5cb836c4c8485fdcb525e9bbb9015e949b"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2804acc101f004c5310c58060323dded8b8ec8bac995d0cd56aa0ff33ac6a832"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2804acc101f004c5310c58060323dded8b8ec8bac995d0cd56aa0ff33ac6a832"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2804acc101f004c5310c58060323dded8b8ec8bac995d0cd56aa0ff33ac6a832"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cbffab49aa1f94d2598497b9259db43bd6d4a3870a3da6874843599179dcb0c"
    sha256 cellar: :any,                 x86_64_linux:  "a402b0cb8b0aa15216e2bffe7252991653293b96d7d2926aa68f6b8d2bf5bfdc"
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
