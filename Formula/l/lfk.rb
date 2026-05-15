class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.8.tar.gz"
  sha256 "1565c4eedf1104372a4d00990b374af69275046e7632383e121440a5415a11fa"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "565b0d37537530a60234cd91e912744b69a11fe8ae97f1306a216a8cf6eab169"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "565b0d37537530a60234cd91e912744b69a11fe8ae97f1306a216a8cf6eab169"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "565b0d37537530a60234cd91e912744b69a11fe8ae97f1306a216a8cf6eab169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a4f36edea24b2d972d2918b756d96e2d26e39fc4b7979ee9c54adca4464028ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "885f46b8a6af54913b020e8b091ac7bc72649cd05128f433ea7bc87d20863d79"
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
