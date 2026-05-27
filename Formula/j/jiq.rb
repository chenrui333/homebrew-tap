class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.28.1.tar.gz"
  sha256 "b2de9a2c44c5dd5af376d2c50848f5a353dfb3bab55eec17cac72040e956a56f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1b83bc8ff2b2249d2bcc5bfa7b095e137b16838d5dc3639ab7735579285c0fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3bcc415c39b2e45fc35b946fae51a86663a1d6d585ab98f14d52f278449c974"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cc44b98058ef2bd6813d1c2b616a24a357fd575351bf4c14092d58f69edd138"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88c223a63e019c2d5b5293ab96a13a75da354f78ff74c68b5817c924881f1dfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a851f213a06c66aa9010df5e6e4c88054c490595297130157879d63da561f14"
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
