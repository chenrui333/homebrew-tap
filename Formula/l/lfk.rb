class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "e174f8a7dc31cf9b02ad6f021a78b548434a288e215d8e8f965f1c9cfbd8a7d9"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c54c2dafd83339f93e4d2457c49d068365706d8dbebf1c3e28934254cde20f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c54c2dafd83339f93e4d2457c49d068365706d8dbebf1c3e28934254cde20f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c54c2dafd83339f93e4d2457c49d068365706d8dbebf1c3e28934254cde20f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca492ffdd042a28315b35a2a2a908478777e3a2d6254aa2031fac3a52feeb480"
    sha256 cellar: :any,                 x86_64_linux:  "15875b775e8d0dbd13931790be743fbd5272b707332b0e9a27507458ae044d7b"
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
