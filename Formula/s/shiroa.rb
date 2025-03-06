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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c6a57393e2517108621b4e595f036659996fe1110d535071cfbf6f8e3e0b54"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c75cb7056a102eb05d0cc07cca5f40e02e30d612c6d049ce2a675d46cc51cc9"
    sha256 cellar: :any_skip_relocation, ventura:       "bfddb0f8bc3fa212c80c7397dd38de01839ad78c79265b7dc381cc23ddab09b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92c74d1f1a08e998a9b30c65490a364443efbb5e59f1acb0d15f0bd614fbf8c8"
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
