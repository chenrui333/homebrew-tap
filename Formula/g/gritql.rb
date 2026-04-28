class Gritql < Formula
  desc "Query language for searching, linting, and modifying code"
  homepage "https://docs.grit.io/"
  url "https://github.com/getgrit/gritql.git",
      tag:      "v0.1.0-alpha.1743007075",
      revision: "fe3643396dab7b5cfa62ccd76d23cb0f03cf93e0"
  license "MIT"
  head "https://github.com/getgrit/gritql.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "da42f4f8c14409bcd378af659fb666a2eaae686384e45ca9b48e6539104f12c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c788c59d0f1bbfda8ef4ce9c7017449f3c4e6fc82943823bdf0eaad33811265"
    sha256 cellar: :any_skip_relocation, ventura:       "04935941062b0622d388c7ee2335d01ccfb4b1ac517617dc979a849d86ec18ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b652a906f5a1f716360ff56f8fa68b1e650c45b6a67791ccf4b81b2b410cd53"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli_bin")
  end

  test do
    system bin/"grit", "--version"
    system bin/"grit", "list"
  end
end
