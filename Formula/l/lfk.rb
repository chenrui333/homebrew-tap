class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.15.15.tar.gz"
  sha256 "e6815cbe8f91755e613db25471e9a3e2db33d10a0cf5acb5ac83ba6b684c7035"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f999df6fbeaedf74c32e4224d15ff0edae0994470de91f248dd07e1daa6adf96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f999df6fbeaedf74c32e4224d15ff0edae0994470de91f248dd07e1daa6adf96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f999df6fbeaedf74c32e4224d15ff0edae0994470de91f248dd07e1daa6adf96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b12e8aa5d7d7f286fd4a1a1b490c2b183768262bc4e74c765fe5dcd62c00b71"
    sha256 cellar: :any,                 x86_64_linux:  "1a7315f213063775e4b56c13c75c839e66512f96e92adf6c6f16cb411ff2ca2b"
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
