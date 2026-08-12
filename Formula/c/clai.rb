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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ef2f8260f00762184d927763aa8e8d805ac57a86807e71a0e337b318165432e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5ef2f8260f00762184d927763aa8e8d805ac57a86807e71a0e337b318165432e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5ef2f8260f00762184d927763aa8e8d805ac57a86807e71a0e337b318165432e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad8a91a8b8fd1a072f10327ee2c2430b81435256172e7673c2e77ce9849eb82"
    sha256 cellar: :any,                 x86_64_linux:  "74c7fe0857d0cbb1f4f9e45e1ae13dc9e9cd30e89d8c8e8c3c6df6102459fbec"
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
