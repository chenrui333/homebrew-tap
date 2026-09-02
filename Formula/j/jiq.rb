class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.34.0.tar.gz"
  sha256 "0623a1240ae1b8de2ec96aee281ad147af476289b200d0761bdf0d6010f3f76b"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7320a8f1d00f0ce8b25bc5ad945739a2810fd53d5b4310b3c0727203cb94aa2f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da2e1521f26716e025254664f57e6c3fdac1a78ca881035faf281b435aa358a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14e55e1f5493ada0ce7722250f2c27b226b5023590d7c94f3ab06c34e4167645"
    sha256 cellar: :any,                 arm64_linux:   "87fae827e9312fac1112b573ebe9972c23db7cb973ae64474c846823e6b7b08a"
    sha256 cellar: :any,                 x86_64_linux:  "c7f656c70075123644c3d78669c4de1a215bcff825e4f4db6bf07a1807e67948"
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
