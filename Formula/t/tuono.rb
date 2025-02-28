class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.17.10.tar.gz"
  sha256 "498808e1cb98c87d6934d1e3fafc014da8433dceb6e0667ec6d5f52972d5db65"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1ab2fe0c6e00c045729fe3e1097ac149723b8da3d68ae0a2f8cebe6d038527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09a389cb7822e6a33c423a7d96d967d4a9910b37d6860c9f4a2d7228e4e3946"
    sha256 cellar: :any_skip_relocation, ventura:       "c51eddec5d027248b7239235abc9059f969315c89c167d4e42d488c02b3553d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27a74f8ac90e355a0c7652afe5ff8ebc6037d1dae898d59966523d217b887b2f"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
