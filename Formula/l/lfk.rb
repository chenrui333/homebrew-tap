class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "6dfc9c208600621c01897e0354bd84ff2855d3dfb9902da0c978dbdd6ef00808"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7abd0dff8c556190ef735ea75ac8203579e3bacdad5fb64df17ad354312d4e34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7abd0dff8c556190ef735ea75ac8203579e3bacdad5fb64df17ad354312d4e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7abd0dff8c556190ef735ea75ac8203579e3bacdad5fb64df17ad354312d4e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d24a7aeeeb99544a2ff44a517117d0bdbaf764453bee5694fc5fbe21552928a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69cae4c55ab58c30cdde7e8d4e1a42bdc17538f8421206377663413483987e62"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
