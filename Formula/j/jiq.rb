class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.32.2.tar.gz"
  sha256 "cda72722200165ce4272823908686ecfb99d06f08850c54b72a2a523ac2cf549"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c0540f616b6801c4f2ca925e46d3a6d63825bee2064a72f9c103cd059ec1739"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5777b49ec4215bb82840c18bcd1551800ce09b9f9c756bd7b12144db06b229d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bc9c5b12730985e7d8f13d3a6fb0c1258bdca2278e8204db9387437ffe9e1b5"
    sha256 cellar: :any,                 arm64_linux:   "78d44ad4c352938f5e5b1a0e4fdf972d1d983ed0fabf0ef6f66544e91534628e"
    sha256 cellar: :any,                 x86_64_linux:  "eb6dcba4c99b49cf3c9ce6ada22c70566d50b456f43bcea95d2f30e5d95f7ac6"
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
