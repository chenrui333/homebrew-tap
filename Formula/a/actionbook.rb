class Actionbook < Formula
  desc "Browser action engine for AI agents"
  homepage "https://actionbook.dev"
  url "https://github.com/actionbook/actionbook/archive/refs/tags/actionbook-cli-v0.10.1.tar.gz"
  sha256 "d4394f4e37237f05991200398e71ca760bbbfbba97b1a83a2ee5272908ec48a2"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de40ee1bd4ff913e9077375f643f0a9ccd9c5687481e1278ddf759aafd82c9c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6125465a4b46ef5b331efd1761bb8a7c4244357e9c8c26e9e43ce68738f2d6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f71ebd4eb1a842eab51da6c006589a5b97dfeb6f20350a56ec8221cf12509a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd3997aef6d3bcecba61f7d75ba4a1ad87feb21a46341681494ea9ae9b059d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe02bbaf8320eb596520f13cff2e6d09409665bcb530f2a561c78999800629f3"
  end

  depends_on "rust" => :build

  def install
    cd "packages/actionbook-rs" do
      # Keep binary `--version` aligned with the tagged CLI release.
      inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
      system "cargo", "install", "--bin", "actionbook", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/actionbook --version")

    output = shell_output("HOME=#{testpath} #{bin}/actionbook profile list --json")
    assert_match "\"name\": \"actionbook\"", output
  end
end
