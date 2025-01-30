class Shiroa < Formula
  desc "Tool for creating modern online books in pure typst"
  homepage "https://myriad-dreamin.github.io/shiroa/"
  url "https://github.com/Myriad-Dreamin/shiroa/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "0f91d352b6807f531e3913c2bb61c61a03b03a54ea8482d5c807ca7d9b32b826"
  license "Apache-2.0"

  depends_on "rust" => :build

  resource "artifacts" do
    url "https://github.com/Myriad-Dreamin/typst.git",
        revision: "2ff6c6ca91bfce6a89c3fac1905ebc427df156b0" # branch assets-book-v0.2.0-2
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
