class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "d28cf05547496e6b19f06d3432b129a39c1d13de4e1fe92ade3e4e210a5bc55a"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbe0081b10d54e165654d51329f3bb525eff274256861d3bd5d5eeea92d2da7e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbe0081b10d54e165654d51329f3bb525eff274256861d3bd5d5eeea92d2da7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe0081b10d54e165654d51329f3bb525eff274256861d3bd5d5eeea92d2da7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62f2b221db9811553ce6f2d9c7a4b02d9b7f70512df87035f7397e603b5ae5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "618d827eb3d284b88c80b958567c43c9913708eaf675dd38647ec2c1f19dd299"
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
