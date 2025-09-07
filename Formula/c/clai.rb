class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "fbefd120941e01320bfccbccada6614014c0626f969ca4ace9a6b489333fe165"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6bfd096a9b7bdad13bb3cbd0b08801d82bdcde574ed9af313f80e9a6e884d11a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c695cce3e3bac370c0dac4d5732f02862625e479e376896b0372c8dd8d2473b0"
    sha256 cellar: :any_skip_relocation, ventura:       "87427cbc902625a5c046673857a9ad55d0f6aff54c6cd4ecd5491407c41acbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90056778a858a8b5a98fad39b0cfeddad78a031578bf1ba58f6ae923c8bafaf0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"clai", "-h"

    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/.clai/conversations"
      assert_path_exists testpath/"Library/Application Support/.clai/profiles"
      assert_path_exists testpath/"Library/Application Support/.clai/mcpServers"
    else
      assert_path_exists testpath/".config/.clai/conversations"
      assert_path_exists testpath/".config/.clai/profiles"
      assert_path_exists testpath/".config/.clai/mcpServers"
    end
  end
end
