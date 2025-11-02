class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.8.4.tar.gz"
  sha256 "67350c02c64f8bfcd5348d55a3f512198cfe056beb0b4fee44c69766b154b3e7"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee3da6bf3fc06b693c1abeb235ed470f183e3fc0c94a0245d355f467ea2a4a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee3da6bf3fc06b693c1abeb235ed470f183e3fc0c94a0245d355f467ea2a4a72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee3da6bf3fc06b693c1abeb235ed470f183e3fc0c94a0245d355f467ea2a4a72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2e03bb0dbe3176d1960a13077de88426baa63d420a92b1a9ef0815a129e12f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9dd1341b2944ba3b27690e354b4fcc4adf69d11670810280fb1a914641788a3"
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
