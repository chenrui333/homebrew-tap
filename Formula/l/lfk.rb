class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "169aac9e41f15a195bd5ce95eb5d0b9ffb94dd1ebd53bea2e081dbbf3a850775"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7428c5886bfe753aa34be8564700a1de0cf51560214dceecdd5251e43f5c8d94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7428c5886bfe753aa34be8564700a1de0cf51560214dceecdd5251e43f5c8d94"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7428c5886bfe753aa34be8564700a1de0cf51560214dceecdd5251e43f5c8d94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac1941983614f2b5f9472d6350953c6e89bcceb46734bd91b83bc46fc0abde7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5e1be760b95eec9a15118f72da6f8500e8545801aaf48215965f1b8ca93dfe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", "completion", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
