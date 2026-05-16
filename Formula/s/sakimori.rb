class Sakimori < Formula
  desc "Cross-platform supply-chain guard for package registries"
  homepage "https://github.com/bokuweb/sakimori"
  url "https://github.com/bokuweb/sakimori/archive/refs/tags/v0.34.4.tar.gz"
  sha256 "cb00e2fc32b58ba7c292b6c746928afd303a184f7efccbca278a83a6eed7c4df"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/bokuweb/sakimori.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sakimori")
  end

  test do
    assert_match "sakimori", shell_output("#{bin}/sakimori --help")
  end
end
