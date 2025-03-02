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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1703a24ee1acee247f0c197399e37817715059353f92f9dce17d91113d9303ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93c4f6f87df88ef35b636a9367b88c8261f8c112a279235faf30b0caf1657a11"
    sha256 cellar: :any_skip_relocation, ventura:       "2707be955ba3567dbad7525895489c7b6c18263075c394c98c74508722747769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acfe018a595db7d4fcd3d182b68ceb25e7524074a3138eed1af57eba9195ad9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/llmdog"
  end

  test do
    # llmdog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/llmdog --version")
  end
end
