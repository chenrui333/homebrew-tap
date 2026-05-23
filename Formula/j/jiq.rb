class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.23.4.tar.gz"
  sha256 "ee7d1f6b6c3a3f01d268d39129357d6502a22fb48beb2f9666b06d9b0fead935"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0869f206d1dcc5d85525af3703fe453df4f5cc505b72feeb7016dfbf82a8501b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b095306a52a6139eeccb0d0dcc35a975142fdb192b4b5918548af9644976876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e46e47bc816cf9c8142d97f9f48e4e3ad0cd7fa5ee44cd975f9c293e15aa706f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39d4e55ce2a904833812c69c9844d639a5275bb520501612b8cc1146e73226aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79cfb4dd122de966ab87f53dd2baf88c2ec83d88eb5dc75cd457080c9ae8732"
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
