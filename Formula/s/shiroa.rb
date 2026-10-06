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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e76b20ebebeeb5ba6a1b8d5147ff6d0d204c7477bcc8dcbea113a0431a6e52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa49959d8033da02f0f7036da89d8918ea9e0544db1e6b62af948244a1c93f11"
    sha256 cellar: :any,                 arm64_linux:   "67fd8e9404cae546400f5e1f643f67d15c0d7eaade69e0255672d8e2f31fa8e2"
    sha256 cellar: :any,                 x86_64_linux:  "cc39835ac759e0c5ab36569b50f9b51ca3f453d24a177ad9ab3b88d9638ffa84"
  end

  depends_on "rust" => :build

  resource "artifacts" do
    url "https://github.com/Myriad-Dreamin/typst.git",
        revision: "537c02e51c02973b3f82a81fab45c80a45840f71" # branch shiroa-v0.3.0
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
