class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.22-r1.tar.gz"
  version "1.10.22-r1"
  sha256 "6c94649fc078ec2bd69f6137195d76041665f37ae88fe45aedc54d337f1b13ac"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87213ea4e08725e8db1e2cbe1414521a70989c0b3dcaa0f1fccfb29844b15e5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87213ea4e08725e8db1e2cbe1414521a70989c0b3dcaa0f1fccfb29844b15e5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87213ea4e08725e8db1e2cbe1414521a70989c0b3dcaa0f1fccfb29844b15e5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b482c46d99fdf9f866846f33a25f9f48bc63ee2665833b14fd75a35983a8d5"
    sha256 cellar: :any,                 x86_64_linux:  "7a8fd52cf26f3cdf7bdb2fcc0c0f498521f4dde0b5d932d8c577268c1851b544"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/baalimago/clai/internal.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/clai version")

    output = shell_output("#{bin}/clai -h 2>&1", 1)
    assert_match "Usage of clai:", output

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
