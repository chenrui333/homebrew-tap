class Claudio < Formula
  desc "Hook-based audio plugin for Claude Code that plays contextual sounds"
  homepage "https://github.com/ctoth/claudio"
  url "https://github.com/ctoth/claudio/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "746347a429d25dd42bb23c1d59b8bb0e3a4ef0ff3f106d94950813acab19b1e7"
  head "https://github.com/ctoth/claudio.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d92510efeb56363ccdfb54a0515d0f112a2e93c74b3f203bd3b709d094cbc567"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "053090cfd96267426d463806506409136642efbeb8b66bc2c8b8aff28fbd67bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1621699d2083d80acab1dabf9d25542d371513fab9a710ea27f91f944b1b89b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aa4f8caf0ebac1b4fb7760b31cdf205213866c2e832ff33a8f2cd3a6f4b1b08"
    sha256 cellar: :any,                 x86_64_linux:  "0ae740e18f31876168d78dffeb1952e6a75359c3d794e3965f03ae2d05aeffb9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/claudio"

    generate_completions_from_executable bin/"claudio", shell_parameter_format: :cobra
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/claudio --version")
    output = shell_output("#{bin}/claudio analyze usage")
    assert_match "No sound usage data found for the specified criteria", output
  end
end
