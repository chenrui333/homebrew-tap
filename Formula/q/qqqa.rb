class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "a1274ad02b74ccab7be9dbe2034cdcc817096ad8067c1d42b639a40c94abf864"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b28644cdbbedd452ec7996ae3f0c9b5631353d5dcdb28e64595867e70f951bbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e94ecb76d9763399b6c576a10cc88888056a89cd8f4efba6020019598eab43c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb752d18eec21e4c2c29ca849231280f6699de00d78b8d1274a86c52da6f7050"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26138e39e35ba5b1aa4791d889b00c4680b2a7752d6bc5c8c4b6b45b911840ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ffca88afd021611566bcdb4ab1df9c63db255a798ccf49f00f00882879b86d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    %w[qq qa].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    assert_match "Error: Missing API key", shell_output("#{bin}/qq 'test' 2>&1", 1)
  end
end
