class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.7.tar.gz"
  sha256 "605731e069cfa0e5cbfd3a40700f1bcee974ac1998df605f570f299034451a4e"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15709769913ebcc2e20cbbc7060a9a2b572f2f646d5954c96d75a56d3eaa48ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15709769913ebcc2e20cbbc7060a9a2b572f2f646d5954c96d75a56d3eaa48ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15709769913ebcc2e20cbbc7060a9a2b572f2f646d5954c96d75a56d3eaa48ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65fce16ea218da66056ae76c3670c17e7490e74f9164e9712c85b82757f73e29"
    sha256 cellar: :any,                 x86_64_linux:  "0b8b1206df5134c39d07522e75dec5049d12a614ec59b28a97a123840b2c6c25"
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
