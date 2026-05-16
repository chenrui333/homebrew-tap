class Sakimori < Formula
  desc "Cross-platform supply-chain guard for package registries"
  homepage "https://github.com/bokuweb/sakimori"
  url "https://github.com/bokuweb/sakimori/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "cb00e2fc32b58ba7c292b6c746928afd303a184f7efccbca278a83a6eed7c4df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/bokuweb/sakimori.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8969c98b032ebde73e609a44cf8e098fed0d76cc054927a36fc1e65da3dfa98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b5de630fda4f844f7f6f1029a3f9f048e1d8bbe87ec8da624167361c8ff09ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1cd7b0a3d03b6963b4c557c90a91c4b69df22f8c03d8ec496e49a38e659037c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b2920900a823039ddde5393fa4badb6bf4b59f9d92b27d888f0cbfcf445b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab34e78a6471bc20c8a46472a04133b27da021583c201e473bb328428def811"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sakimori")
  end

  test do
    assert_match "sakimori", shell_output("#{bin}/sakimori --help")
  end
end
