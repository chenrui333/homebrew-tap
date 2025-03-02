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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e2a23352cf7b1233797f2d57baad9ea407b7a89bb70f4a9f47ab1118b36bff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdaf86589210c41a912c21de2ba068d9eec285b22dbc6a5d263cac74b446239b"
    sha256 cellar: :any_skip_relocation, ventura:       "139c2355f841377ae5ca2d443d810b4d27724fb49f403599039b981a5cd401cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4cc1605dc5e09f03d5a77cc42752c7f42b0d9adfa99600e609af95b277ddf5eb"
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
