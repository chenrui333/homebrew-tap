class Livediff < Formula
  desc "Watch file differences in the terminal"
  homepage "https://github.com/SoCkEt7/Livediff"
  url "https://github.com/SoCkEt7/Livediff/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "41b3d22f646cd16beadd4ff72868f76badf561f93c9996329c30ef6a40d576d7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/SoCkEt7/Livediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3c76b78a3e3e929a45147d206f4bc34e4c0da04057ab7cfdb825f71f6724e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7077c3d0da783e8b83aaa16d2c10f3aecfa8dee97b3cf5931c5b01064320b8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c11de5c25eb45ce8c77b8ac5015d587c13eb6435095ee6d81ca43b915b9b9e83"
    sha256 cellar: :any,                 arm64_linux:   "2f3b612bfd1c27f3f9b0cab767dcdd6e5555266cfadb0dfc44c72bed24a7e95c"
    sha256 cellar: :any,                 x86_64_linux:  "86be01a7e8afd53043bf32f278b5142dab5825e8ba008949650454bd3a1e4821"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livediff --version")
    output = shell_output("#{bin}/livediff --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
