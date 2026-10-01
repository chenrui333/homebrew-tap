class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "a129b6b7b81382a6983e1cc05e704925cbe8bc763bffa014dc61022ac38a65ea"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88ca8e41bf300ac8205aa13e960623e1c285521a25319087e90a23c0ed0fd6b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88ca8e41bf300ac8205aa13e960623e1c285521a25319087e90a23c0ed0fd6b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22b511cabec2e66af0e06663f4bd7089d62557aa8d86d5c2300e9d96c800b77b"
    sha256 cellar: :any,                 x86_64_linux:  "9617284736a880272a7ee86584f57b57286e64f94b3dad874a4d304b0ca35290"
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
