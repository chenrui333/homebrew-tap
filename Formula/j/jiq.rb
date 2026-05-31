class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.31.2.tar.gz"
  sha256 "0efd9a326e9dd76d3ed67d6e0acd78767ad704cd850b496baab845dcb426d407"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "091a32b7deefee6c5abd460db7a00b27ae0645ad710613a49dfa3b48773047a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bead19499206a2f3fa0c43e138ae572b7cef058df4aa818fb9a73d668f255e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e7e84e4afb1b89a833e0320b5015febeeaa95b0f565c88b6114c6a6ccd86b34"
    sha256 cellar: :any,                 arm64_linux:   "b56f788b1d4f11d72ab53e2342d8ab0950d22000cecae53b39157970c167191c"
    sha256 cellar: :any,                 x86_64_linux:  "f7b8cafb0da1a1a017b2bfaf071ac46c3f45b4a26e9fd4e9afa6ff6863ccb6dc"
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
