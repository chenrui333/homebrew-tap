class Paq < Formula
  desc "Fast Hashing of File or Directory"
  homepage "https://github.com/gregl83/paq"
  url "https://github.com/gregl83/paq/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "855e4ffea1acc937a924d6db6df2ac48198fd7128ee05508477662243c33c866"
  license "MIT"
  head "https://github.com/gregl83/paq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ab21c3c333c5c764f20ba62bec3de92a4de893ddb5324a7bd1640dffe8ee2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25731f65154dca4c4208c66bc6640d5bf6b2c8087391797ece26fc99f9b2651c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93a369167100c41bf8fb421e2f7c0eb46bdd0caef68c9682983daf1bb295452f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cdc5395eb88d45d76d0cd72a375693214e0c255cf72e209e9470fb68d2f434b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823019a70765135effb8c395f125e2ebdcebf9be3ff84137e20aae7b46539492"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paq --version")

    (testpath/"test/test.txt").write("Hello, Homebrew!")
    output = shell_output("#{bin}/paq ./test")
    assert_match "eb9122ffff587d1cb9e56682d68a637e8efaa6c0cd3db5d90da542d1ce0bd2c2", output
  end
end
