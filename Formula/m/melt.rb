class Melt < Formula
  desc "Backup and restore Ed25519 SSH keys with seed words"
  homepage "https://github.com/charmbracelet/melt"
  url "https://github.com/charmbracelet/melt/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "e6e7d1f3eba506ac7e310bbc497687e7e4e457fa685843dcf1ba00349614bfdc"
  license "MIT"
  head "https://github.com/charmbracelet/melt.git", branch: "main"

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
