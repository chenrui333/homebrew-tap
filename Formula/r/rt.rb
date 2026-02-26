class Rt < Formula
  desc "Run tasks interactively across different task runners"
  homepage "https://github.com/unvalley/rt"
  url "https://github.com/unvalley/rt/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "16eec7218a0c4cc0bee7734a54e3629df85dac6011c9caf070caeaa3db61487c"
  license "MIT"
  head "https://github.com/unvalley/rt.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aff078ab614ce072182f276fa2f3fc3d3b6a183f347842a556009108dc97fddb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3080e124558840799be3800339ae31b4d8196145374bbc0f305495b72e23b14b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e79a555f2ec1fa803810db54d280f7cc0166af007b9dbe11ad9ab960179f096"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "873af0aff1ffa79dca70712640ee0d6e7f4a8f532e21e592f7e16b5542cbcba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb493b563e2d06e4ea0a6dc282636b1aad684775605646b9ed201a35bbe51cb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rt --version")

    (testpath/"Makefile").write <<~MAKEFILE
      hello:
      	@echo from-rt
    MAKEFILE

    assert_match "from-rt", shell_output("#{bin}/rt hello")
  end
end
