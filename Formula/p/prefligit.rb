# framework: clap
class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.11.tar.gz"
  sha256 "cc07ad9b9a505f2450d6bd6e13c704e53b49b6ce77283223b51892836774675f"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f705a00d426442a91c419612cc252e904328d4c37451ded82a1867319f3b0e0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1f5b838417336b415fead44ebee7e0e2cff7047497a6ae6be51fb89af9f8105"
    sha256 cellar: :any_skip_relocation, ventura:       "2aa604774431fb6bdef4917a4aa33dd4800477b0df520e3e526068846a97b4b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8afe4ad0a051c2c35e20767f0c16e5df5a0d1ea046a205198095e70100ce955"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
