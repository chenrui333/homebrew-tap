class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "c3f416fb42c12be42a7d70c2d0d380f7105ec43b07c1365a7509363595476a12"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74ccc8eed79237a562b95fd295b5a2e4ab80003fce9c52deeefb4ff4953e8838"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ccc8eed79237a562b95fd295b5a2e4ab80003fce9c52deeefb4ff4953e8838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74ccc8eed79237a562b95fd295b5a2e4ab80003fce9c52deeefb4ff4953e8838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfbe669dfe5375e6e5ddfd331f0a1933c96275251dd7705f9181d8d0af850404"
    sha256 cellar: :any,                 x86_64_linux:  "616fc363f73e7dd924ba09b125e63ab830eeddebb376cc635faa7ccf1d95b19e"
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
