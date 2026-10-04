class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "60ae35de73ec3d91a4e09e49c0087a660644f38ac0cc1234d1079d0efe8d2f10"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1bac3e17d5f9b049e1e05c1a1bf0a2279ac78df686b14e91bdaaa184f317b1d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bac3e17d5f9b049e1e05c1a1bf0a2279ac78df686b14e91bdaaa184f317b1d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c72abd59bff0f055abbce4b678ecddbf8c849b4da5fc2627d50db2158cc2d08b"
    sha256 cellar: :any,                 x86_64_linux:  "ea50bdd3fe2a0fc1a4f2f652292781fd8d93fe22036885e1dcac078d965a57f6"
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
