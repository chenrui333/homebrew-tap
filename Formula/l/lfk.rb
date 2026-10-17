class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "900823213548673c30b6121469e38dd6078658d800ab4a9e9d4b5a1ea1e166fd"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed0b5c8cec7cc15238fb4ec98766277fd556c7195cf545cae8d21947cc1547c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0b5c8cec7cc15238fb4ec98766277fd556c7195cf545cae8d21947cc1547c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9f5cc2e854ce8dd4b591c06d0d95369c8d8e9d0776e658a7e26f3e90f841d73"
    sha256 cellar: :any,                 x86_64_linux:  "60ade037acbe3d81210df0a52232bdbf9f53298d0a5de061836aa9beb7bd1f4c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
