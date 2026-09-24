class Gitsocial < Formula
  desc "Git-native cross-forge collaboration platform"
  homepage "https://github.com/gitsocial-org/gitsocial"
  url "https://github.com/gitsocial-org/gitsocial/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "e0644c0386b32dc09cd382f5bb0c8b9f5c10ad0f10dd8093b6be5c66a04ead8c"
  license "MIT"
  head "https://github.com/gitsocial-org/gitsocial.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9831d95a902346a49d7a7e79a1dec6fd260e4481794e5d0fc2369853aab66d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9831d95a902346a49d7a7e79a1dec6fd260e4481794e5d0fc2369853aab66d31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "750d8548848e895edfc954e361c56529a7f0122829258bc2ef8ed230a69309d6"
    sha256 cellar: :any,                 x86_64_linux:  "52a48c191762d4defa92d5fdfa015da4f1c97529482b9c5e48e23e81e68dae56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cli/gitsocial"

    generate_completions_from_executable(bin/"gitsocial", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitsocial --version 2>&1")
  end
end
