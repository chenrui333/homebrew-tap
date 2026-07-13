class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.10.14.tar.gz"
  sha256 "59730f0e9e7740ca67c94717610491bdac3c578044543fee7f8fbfb22aa5bf52"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "724c544feb41ce26ce94ff3895a383f12a95d3da58fde053d644179745b0d2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "724c544feb41ce26ce94ff3895a383f12a95d3da58fde053d644179745b0d2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "724c544feb41ce26ce94ff3895a383f12a95d3da58fde053d644179745b0d2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1bbfdd7e058e300e6e4ad54a9765eeb642accc90129bd81f3130c80cb02d01e"
    sha256 cellar: :any,                 x86_64_linux:  "7fe63c0e12ca84833f4e0f06b6df825e85a6eb698bb49010bc3c40f79bc6a57b"
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
