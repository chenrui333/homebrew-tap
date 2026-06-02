class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.4.tar.gz"
  sha256 "0b170a8b632dd4f840e72f7b438fefa206231b9a81bdca82fe48663a55ba938d"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c938d28cfb4337e6f8f5666d84d85bb4e3177df54216a936579817fc95d0548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c938d28cfb4337e6f8f5666d84d85bb4e3177df54216a936579817fc95d0548"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c938d28cfb4337e6f8f5666d84d85bb4e3177df54216a936579817fc95d0548"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acdc03b25a5e5b99f1d6279bff4e71ad84b72594f5a266af1656e6fb9bf9764c"
    sha256 cellar: :any,                 x86_64_linux:  "ce43fd2ab527c48b6578a9327cbcae0feb96233855fd2366657b0e4d9c620a69"
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
