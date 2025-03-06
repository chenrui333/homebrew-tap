class Shiroa < Formula
  desc "Tool for creating modern online books in pure typst"
  homepage "https://myriad-dreamin.github.io/shiroa/"
  url "https://github.com/Myriad-Dreamin/shiroa/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "724f5247fb40e9adedae133c0ce103a7b2ab91fa97e704d6bea544ce63559488"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bb34a5faed03acaeeac7b12a51631e0ed9177b9a256c82f42c86ea67370d4a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e4b3b8fbea516e3cbb1ba0b36ee6e2ac370a6bc0b2d98fbdef5dbe3428e7f8"
    sha256 cellar: :any_skip_relocation, ventura:       "71472b5ae79b38a724e320ab5d676f4d1e4e578044eed460925faf1a94e00cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aadbfc39644788e819e8b81a32a6be21f58c0525b1dc81e64766b11b7ed6da0e"
  end

  depends_on "rust" => :build

  resource "artifacts" do
    url "https://github.com/Myriad-Dreamin/typst.git",
        revision: "537c02e51c02973b3f82a81fab45c80a45840f71" # branch shiroa-v0.3.0
  end

  def install
    (buildpath/"assets/artifacts").install resource("artifacts")

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shiroa --version")

    output = shell_output("#{bin}/shiroa build 2>&1", 2)
    assert_match "error: file not found", output
  end
end
