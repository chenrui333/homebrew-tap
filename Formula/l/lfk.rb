class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.15.tar.gz"
  sha256 "3172412630e1d25ce0433bfcf9dbc9c434875722354d0a18bd903f96b4e59003"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e304e3dad478d66a7d05606fa6eff39614738dac11abe39bd81f7dc3e794aa2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e304e3dad478d66a7d05606fa6eff39614738dac11abe39bd81f7dc3e794aa2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e304e3dad478d66a7d05606fa6eff39614738dac11abe39bd81f7dc3e794aa2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63c55e74fb2badaabb553344c7ccea41101864db6a6000724733c021856ac4b7"
    sha256 cellar: :any,                 x86_64_linux:  "af7f87fd5b71492565a8e97e92fce4e1348da9d0643aa6748703321b4d9bcb3f"
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
