class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.7.tar.gz"
  sha256 "66fb1d267344a87bc97fa3856be9f1a006fc02b03803904ce225a4568720730f"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01886ee11168b9da5558c2d0f291b595624d890b57438a4ad6c89c8267fbecc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01886ee11168b9da5558c2d0f291b595624d890b57438a4ad6c89c8267fbecc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01886ee11168b9da5558c2d0f291b595624d890b57438a4ad6c89c8267fbecc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcdcfa72b1fd30a2052909790059602cbf0c03837b7a1dc4fccca797b2189088"
    sha256 cellar: :any,                 x86_64_linux:  "d1d93414a31aaadc654e4e1a673f1c1f84f0e1d1fc98d6537ed2f0dcf256c07c"
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
