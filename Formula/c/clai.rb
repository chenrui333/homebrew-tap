class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "4b018579b4fa53af31f52421f0fbdd67a921e5d9f67a77c06c9880d41b23235b"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed92a09b5b85c182f7fa259b04d21c922e27554a83a2b7e3f7e8ececd188d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dcf2018db10bdaca8b40a53673acfe04c5e85ae01f30715828397357f1dc052"
    sha256 cellar: :any_skip_relocation, ventura:       "c41be1c6219da555ab7ded0a48f0f0ed62d0e5590befaf35366a1326afb30a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f164d21cec812675a93ca050b9f50ddfaa33b715cae2ebfcd7711e0ca0090cd"
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
