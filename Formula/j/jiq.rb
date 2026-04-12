class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.21.1.tar.gz"
  sha256 "d1293631a584f728f76a5eb252c7bae78aa2b993cc80c85fcc6bd871ab6d2d3f"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b92d16cc52546d6287797cbbbad708348946462a44c520326bd3afecd83954e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da31ae86182e38af09b165fe334cdc5b1009bfedf5b7c5cdb4c0e9dab41529d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500189605e88cfb18348a7c4a675deaf6d24880a8e195c96fecc6f8adc4b3ad8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6b93db43e36849e61742cb38a731b6b8f75ec7509a3dde6147d4a25e72cd1ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30b833baa9294d44a8e6fd1bbda7ce44859ac6de7ffaaaa0314142d0e2466b1b"
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
