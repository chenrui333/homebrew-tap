class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "d052b1403981d9363e803a11d46ac849178b20d9607ebd914cc78ee3b34083ba"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3cb2c3298ca7bf8c32f84f2eda4b09449bdf611150d9a0b409d7e47e1c44d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3cb2c3298ca7bf8c32f84f2eda4b09449bdf611150d9a0b409d7e47e1c44d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3cb2c3298ca7bf8c32f84f2eda4b09449bdf611150d9a0b409d7e47e1c44d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfce6f2763f191fe45c1d648da4bc5b457af5c8549c93fa1ceaec0c8387755b9"
    sha256 cellar: :any,                 x86_64_linux:  "87b9a982346d76950e469ab0a6308c54d4475312115038c504b06b3c358da67e"
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
