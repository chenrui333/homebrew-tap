class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "b671a5b374bbe01533931b4f4d6f4f5f50c53d6fc15f4c7a9e0d8b174b9983a8"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4fec42cc35541de212ec37afbe97964f657aa4b119ac44ddca0adde0578cb4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4fec42cc35541de212ec37afbe97964f657aa4b119ac44ddca0adde0578cb4d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "650bf7f185f07f11b1c24310a1f7acc322fe1f472cf8d5fcb70b54778ffa508d"
    sha256 cellar: :any,                 x86_64_linux:  "0e3799bd4c221974c5796f3054ab1228ec48ba583004186d05a5ea46c669a0b7"
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
