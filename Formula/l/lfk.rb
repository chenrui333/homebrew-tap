class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "9a788d709ca1eec04b3f1b107e2a2a2a577a4486d63fda5810883341d3021b62"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5aa86a045480c540e191e4ff375d98170169c73fbb964cc4f6a6dde2def501c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5aa86a045480c540e191e4ff375d98170169c73fbb964cc4f6a6dde2def501c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa86a045480c540e191e4ff375d98170169c73fbb964cc4f6a6dde2def501c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1360a75fe70eb160ae1a7e32037ae56951af4872e46117525636f7b14b4211f"
    sha256 cellar: :any,                 x86_64_linux:  "412aa75b636779107ac8900a602dd5da442111e35bfc45f2e8f6b35550d24a02"
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
