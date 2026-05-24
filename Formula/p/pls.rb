class Pls < Formula
  desc "Prettier and powerful ls(1) for the pros"
  homepage "https://pls.cli.rs/"
  url "https://github.com/pls-rs/pls/archive/refs/tags/v0.0.1-beta.10.tar.gz"
  sha256 "fa8203012b10cc3460fac288a4548da735a770090b493b57db83e23d5acbaf03"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+(?:[._-]beta\.\d+)?)/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90c750d9a5ff592726944c76e2e70b3aa4b51ef2c9f14f4bbf466f1522c012ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3413619bda540618680b6ffa34f50007cd478d8d37a528d7c567922e25ae7fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "134445c5c4c0f5c39b1bc4e868fdea1c74f8725e58bca8cf235568850cd5fe3f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afca4d748b3039f797bae88a15df29812533ba307779d964c34b90f03602be10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b61f9b760c5dc437a40757a4ca235a84675aec2ca7c61d8adf784e6c8447b3d1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pls --version")

    (testpath/"testdir").mkpath
    (testpath/"testdir/file1").write("This is file 1")
    (testpath/"testdir/file2").write("This is file 2")

    output = shell_output("#{bin}/pls testdir")
    assert_match "file1", output
    assert_match "file2", output
  end
end
