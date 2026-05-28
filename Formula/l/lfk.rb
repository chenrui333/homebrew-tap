class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "fd98dda1edcb9a789079c8c1f645e928802753d1b72c209bf3cda2d5b5b220f4"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83cdb3156c016dbb05f57ac18c5ae75e083ad198dbea78c430a6e49a79e73457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83cdb3156c016dbb05f57ac18c5ae75e083ad198dbea78c430a6e49a79e73457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83cdb3156c016dbb05f57ac18c5ae75e083ad198dbea78c430a6e49a79e73457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1c64ac5cdd200681651bd8ae21c79c9120df922ec069d8a7435aa57bb324e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf274e615e72bb5418297e03e886e59d92284ec5db8690eaf2fee1a9d5aeb9c6"
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
