class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "fd6c1e85ec353d14676e4de65589188bbb75f0b7e668653c6215923c001dda28"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2bba36ea83e7840fa7c1ea985ed3db919b7db69576a685105ebad686126f45cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bba36ea83e7840fa7c1ea985ed3db919b7db69576a685105ebad686126f45cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bba36ea83e7840fa7c1ea985ed3db919b7db69576a685105ebad686126f45cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69e19d98174afade1091179e8ceca9314fbf147f3f8e55c6e7c0a8f6df0fad01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc10ead061e81cc79964c4cf07111d8b687b96b18a57d62345b6fd3cf45b451"
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
