class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.26.0.tar.gz"
  sha256 "9823ab9202826180414ee6e761212928e6eded45e046811baaac3a53523dc491"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8ae3350991cca8929d1d8be8f73879ea645c5a13cbac719c7c4b0c022064348"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "401e4c87b81bffe2247e21631f76c66c88c678550a3f69c99f36679b4c56141b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a839a303ff85f61747074be85fab2d82d5924e768adcc89cd8ef4512aa6c1c9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9eeb24c721f906e1fa59db439e3097eb1b0162987eca1402c7cd2424861db2e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cb2ef4c3c20f1032f6541f0d85edac718ce79a3db25371468f29a1a2cf3a616"
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
