class Qqqa < Formula
  desc "Fast, stateless LLM for your shell: qq answers; qa runs commands"
  homepage "https://github.com/iagooar/qqqa"
  url "https://github.com/iagooar/qqqa/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "073cdcbc68c1f65a611cf06f84468db1fa4db176bd48795bc3841a5f224f1aa3"
  license "MIT"
  head "https://github.com/iagooar/qqqa.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "144c701460c95624c95192be206ba8d53d6f358ccb62f382d9ef5c706cc70267"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0200f138ddfbc86987e44b0e9d66520e5f8c0652c479320696a4ae9bb4a9adf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3029c4a1788f7f1277f8e5a9cae9aab5ca8ce3bc96f3ef5554bc7369aa848f5b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ed7f2b32a72993867baaeb09cca84c2c882f79bb029d0777acc8529b36c3341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c049a93fce5221fd6faf8c92915ee8250d9fa9665c3063f8f5c58b45ea456c04"
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
