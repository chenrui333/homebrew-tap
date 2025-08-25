class Melt < Formula
  desc "Backup and restore Ed25519 SSH keys with seed words"
  homepage "https://github.com/charmbracelet/melt"
  url "https://github.com/charmbracelet/melt/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e6e7d1f3eba506ac7e310bbc497687e7e4e457fa685843dcf1ba00349614bfdc"
  license "MIT"
  head "https://github.com/charmbracelet/melt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8f772707832f579bbd69f13d7a9a42c59df4c3ac0ea3f5598189ead8a369b00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f70fc9b30392758dc8ac1ad33e9a00d168d75047dbf553c973b0641375c28e9b"
    sha256 cellar: :any_skip_relocation, ventura:       "ebf430c11e2ce70c4b74d6e5bc2f914ed6f2fca36dcc47130f6afb7c646f47e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d08cf2fc29d082ccff9ae4c830c4a0deda41ae3f12dd40d3d28e0f8ad142c39"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/melt"

    generate_completions_from_executable(bin/"melt", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    output = shell_output("#{bin}/melt restore --seed \"seed\" ./restored_id25519 2>&1", 1)
    assert_match "Error: failed to get seed from mnemonic: Invalid mnenomic", output
  end
end
