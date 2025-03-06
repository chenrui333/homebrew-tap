class Bws < Formula
  desc "Bitwarden Secrets Manager CLI"
  homepage "https://bitwarden.com/help/secrets-manager-cli/"
  url "https://github.com/bitwarden/sdk/archive/refs/tags/bws-v1.0.0.tar.gz"
  sha256 "88d25a757ca2f9c1dc727032c600d7c2d90ad4f6c0b3ccac4c1c513120ce34ba"
  # license "BITWARDEN SOFTWARE DEVELOPMENT KIT LICENSE AGREEMENT"
  head "https://github.com/bitwarden/sdk.git", branch: "main"

  depends_on "rust" => :build
  depends_on "pkgconf" => :build

  depends_on "oniguruma"

  def install
    ENV["RUSTONIG_DYNAMIC_LIBONIG"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bws --version")
  end
end
