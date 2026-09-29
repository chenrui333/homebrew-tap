class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "1001c8e8f7f5a1cce630c65e91a2c92e9a7bebeaa563004164be0b37d35868ad"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd49618028406210e16cb1d66630d06531fd6b01ad92601d5dd3ff9694993b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd49618028406210e16cb1d66630d06531fd6b01ad92601d5dd3ff9694993b2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "568b3ee4ffcedcf214ac51a8bdbcd1692ea3c2dab9c51686b413d6ad20ef7ae8"
    sha256 cellar: :any,                 x86_64_linux:  "dc3cd3b2b1389de8db5edd8702d0be5eee02d605122b9c5d9801edda30045656"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
