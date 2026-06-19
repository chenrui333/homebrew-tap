class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.12.tar.gz"
  sha256 "3d8ea0c946e9422d7fa9f954a8531883f1de410aee6eddb9078f62dcbe465119"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f707c59eb60eb606f75d98efca97196393f611c9739fd05c9bb9e6f78eff8689"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f707c59eb60eb606f75d98efca97196393f611c9739fd05c9bb9e6f78eff8689"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f707c59eb60eb606f75d98efca97196393f611c9739fd05c9bb9e6f78eff8689"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9aa59b5d9a3ded8d7dfa263a262b276f5d4ea263a56ed7a82dd626ef9d0e4adb"
    sha256 cellar: :any,                 x86_64_linux:  "16cab694a0dda96ee8efdd6c00d16972edd09add8a2640d9599a2538c79e723c"
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
