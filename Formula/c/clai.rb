class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.3.tar.gz"
  sha256 "4b018579b4fa53af31f52421f0fbdd67a921e5d9f67a77c06c9880d41b23235b"
  license "MIT"
  revision 1
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f706291e1166c4a2766321dc39f5e96158453d8bf2ae4508dfd57c08b59355a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f706291e1166c4a2766321dc39f5e96158453d8bf2ae4508dfd57c08b59355a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f706291e1166c4a2766321dc39f5e96158453d8bf2ae4508dfd57c08b59355a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc4701923b399f716225dbce309619ff4cef0b8d61f2c4bff1e7762f3aabe0a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68f8b8e699d5e5188f64b02a3d7fae8ed3dc26ccd86591a26c10cb334bdd32e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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
