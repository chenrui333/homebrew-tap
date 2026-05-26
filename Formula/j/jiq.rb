class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.27.2.tar.gz"
  sha256 "fe2ed6e2120a27b5047512274c319b699b74b178650f7a2bc51c064bbe4206fa"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a455ca433f406d15931afbc2978d4dbdf4115403169817c7e39cb24dbff8b866"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59f5e43011560b85279646782af1c29c4c91e7fdaf4f090d82759f303a158e70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb287b99320c7be35bb99e60531366f183f1d81a3b44d865c84cc9e6032dcf2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f86fcf45c4ea0dbb6419a3914acbb88cb73cbcc0fcf90e89a7932b393635db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bf7124c7211ddacc656803ddd6fa4b6a0d311001d71fffd5ff803e0833ec885"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
