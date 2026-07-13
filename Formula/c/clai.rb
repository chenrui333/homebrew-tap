class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.14.tar.gz"
  sha256 "59730f0e9e7740ca67c94717610491bdac3c578044543fee7f8fbfb22aa5bf52"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba3a36dc723ef5fa09d3806e0e9b32803d513b2948817b25c29427b07fc290d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ba3a36dc723ef5fa09d3806e0e9b32803d513b2948817b25c29427b07fc290d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ba3a36dc723ef5fa09d3806e0e9b32803d513b2948817b25c29427b07fc290d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "065a8e1cf1e2e4e13c6540bd18b38ecf950635f89bfa9adda23403704813dbbe"
    sha256 cellar: :any,                 x86_64_linux:  "45b5d83a968a98c55485a1a339f15796225e1ddc5e9af50586f9a0e18e3872d8"
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
