class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.12.tar.gz"
  sha256 "180f6dd244e71279a26d6532374ae2703a85195799f5b0323f7aae12f5506704"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0de8e40f9710d6ed6f88556f7c7b089de215e947cb96c7f5a56df6496ab5ba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0de8e40f9710d6ed6f88556f7c7b089de215e947cb96c7f5a56df6496ab5ba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0de8e40f9710d6ed6f88556f7c7b089de215e947cb96c7f5a56df6496ab5ba7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbfd96266c79b0321d21a7a27d804cc9cf07c8b9488abb35a4082817b3e480ac"
    sha256 cellar: :any,                 x86_64_linux:  "09827f0b1315f703ef1b660a73b5621a90d48f88ac8ac2ea5c2008eaef496bf0"
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
