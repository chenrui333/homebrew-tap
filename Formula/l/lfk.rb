class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "1565c4eedf1104372a4d00990b374af69275046e7632383e121440a5415a11fa"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acbfc62f810cad5ddd41fc3831601753fdae1e653da3b713732fe4e16109f571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acbfc62f810cad5ddd41fc3831601753fdae1e653da3b713732fe4e16109f571"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acbfc62f810cad5ddd41fc3831601753fdae1e653da3b713732fe4e16109f571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d53164f92de2093a6262baaa2785e83c9c1238e890a3104f0a99dead8cb386ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c79db9e35a8fd592551faa2f64c50a07a3ed4f6269e1e6706bab37c77cb5e14a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
