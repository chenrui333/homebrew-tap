class Clai < Formula
  desc "Command-line artificial intelligence - Your local LLM context-feeder"
  homepage "https://github.com/baalimago/clai"
  url "https://github.com/baalimago/clai/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "faff64d721afd988a585b729ba848a1382982c9394f65a7b5a12b906534872ce"
  license "MIT"
  head "https://github.com/baalimago/clai.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e65b99d947ee45c0613ceabeea0b7389abfda94138300ac8e79f93426d2615aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e65b99d947ee45c0613ceabeea0b7389abfda94138300ac8e79f93426d2615aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e65b99d947ee45c0613ceabeea0b7389abfda94138300ac8e79f93426d2615aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe5fbf9c2fe8ddb953af9a948d0e14a715a85c9818a00f08b361bd6cfe0c3308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d81adcdbf0b21b3a7c3631839bb1955214891a6b36e0f83593310c6289253b92"
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
