# framework: bubbletea
class Llmdog < Formula
  desc "Prepare files and directories for LLM consumption"
  homepage "https://github.com/doganarif/llmdog"
  url "https://github.com/doganarif/LLMDog/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "32adc9485e80cfd6c91c1215cf797c760f3edc31c5e97d6263ce2685399eb75a"
  license "MIT"
  head "https://github.com/doganarif/llmdog.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5067a30ea820c3241d6361b265e986c6c2d5ab759cc3cc6437af4ca0f5d35095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5067a30ea820c3241d6361b265e986c6c2d5ab759cc3cc6437af4ca0f5d35095"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96daed7282ee15c088f422ebb52e37a28e3e5ec362916820ec6718f468ecb489"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1249f256f39e9efc40551f5f47d56bfede5cda8477d1d07524889676aa92e1f1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/llmdog"
  end

  test do
    # llmdog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/llmdog --version")
  end
end
