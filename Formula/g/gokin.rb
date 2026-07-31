class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.100.132.tar.gz"
  sha256 "b401643a9c1bb4a9a1eeef09fe7e9a74c18f8568a4d6e3200c083635402deab3"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16fbfd6bf2b6a7deba32604fc0493ec920ba1d9d32af7224c29a2895d4040cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16fbfd6bf2b6a7deba32604fc0493ec920ba1d9d32af7224c29a2895d4040cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16fbfd6bf2b6a7deba32604fc0493ec920ba1d9d32af7224c29a2895d4040cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c39a20ceb16ef53df4c71462bc856b8515c1e2f966178492b42fb2504c2dbd2d"
    sha256 cellar: :any,                 x86_64_linux:  "9db893c118b780bb4af6cb3279354f327bbb88ee6a2c9ee5ef70edac9ea88a37"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    output = shell_output("#{bin}/gokin not-a-real-command 2>&1", 1)
    assert_match "unknown command", output
  end
end
