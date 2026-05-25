class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "248e65872ef3897ae2277e342576ffa4333c939453205f90241034782c5c5516"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37a76003467aa561cc49f6fa02ba7e2fe8b7f599be2951a6f725ada16b0e3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37a76003467aa561cc49f6fa02ba7e2fe8b7f599be2951a6f725ada16b0e3cfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37a76003467aa561cc49f6fa02ba7e2fe8b7f599be2951a6f725ada16b0e3cfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ccb4e0a9d5a38b42facdf0554da74bdba780ad3806b472580c986d1eaf5d875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7c0f6673c6e2c59c5981d7ae30a1ee54d66202cbf3a9c163105c60d2a24b528"
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
