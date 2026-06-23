class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.14.15.tar.gz"
  sha256 "d61263f664c23c552f857c776a4631d15208299d583bcced162f61ab0e28064f"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26185e90feaf665f1102b6061ad6503048b78024fc45518c48fb3db5d7acb697"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26185e90feaf665f1102b6061ad6503048b78024fc45518c48fb3db5d7acb697"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26185e90feaf665f1102b6061ad6503048b78024fc45518c48fb3db5d7acb697"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "029660609e280fd7f17b1e883003e17f3d2c8b1ef1414d534d43d6f5a24eec82"
    sha256 cellar: :any,                 x86_64_linux:  "6d48cdda175f182e2cdc765e8d037c85684b3ab768b17bc8ad8e0f4bed7f3c97"
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
