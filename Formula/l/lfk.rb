class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.5.tar.gz"
  sha256 "eeb1ca2de798547e4721bed8064a2e81c389f252e8c344fc46eee2e405fc7160"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db8fc7d56379158b9207da86e478693d0b8448b0fe380baed2f5a943b86e5919"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db8fc7d56379158b9207da86e478693d0b8448b0fe380baed2f5a943b86e5919"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db8fc7d56379158b9207da86e478693d0b8448b0fe380baed2f5a943b86e5919"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74b7ec370b96753363e846270aa3926604d3ff69fc115b54a098af76f4db0343"
    sha256 cellar: :any,                 x86_64_linux:  "74c06cc38db8e47a368beac09935b27a962e0a150dc0ed61503351d113cb9c4b"
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
