class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.31.1.tar.gz"
  sha256 "3aea9e911ec1480218d3f5866f9625060daba255d3f84c177b82ae7d1c451c2f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cc8e8be951febb4c121a05ff10af657c34cd44a87a9c1c9053e83e0869812f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d47583fa241f641789c1a3f000a007ec9ff205132eec24ce689d13526f92ab0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a4b17ec32a9fef8b2e90ad276390ba47cb76252543903f94505b55fa4f3b31f"
    sha256 cellar: :any,                 arm64_linux:   "48e1313815e3c47013b08fb200d1f2345ef3991b9441b3e539c06971503bc418"
    sha256 cellar: :any,                 x86_64_linux:  "1a3f5007adb7f8a73f05707ee9c7787b34b3efe777a4b5dfa46189d66b26a066"
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
