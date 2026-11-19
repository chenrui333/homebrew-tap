class Regexplain < Formula
  desc "Explain and visualize regular expressions"
  homepage "https://github.com/kapilpokhrel/regexplain"
  url "https://github.com/kapilpokhrel/regexplain/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "523b716162a6912e54473b1c7eb87e37dddaea06c80b50203281e8d5da80dbcf"
  license "MIT"
  head "https://github.com/kapilpokhrel/regexplain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "50647d1c31bb6e11c11d384d375bd4e4ce82ed5a7870a61d15f898210d2693e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27aaabc2d5c3acb04674843f502a9a91953df1ac9658ef4a61461470bbec6368"
    sha256 cellar: :any,                 arm64_linux:   "822cf69d497405cd504efafb9b19f34b7ec143db7d4329b539508382ec99af67"
    sha256 cellar: :any,                 x86_64_linux:  "fdb67f5dbe7f8a0e89489a1d2851148abfb19ea04018776cff744c13f3137789"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The release tag is 1.0.0, but Cargo.toml still declares 0.1.0.
    inreplace "src/main.rs", "author, version, about", "author, version = \"#{version}\", about"
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/regexplain --version")
    output = shell_output("#{bin}/regexplain --no-tui --pattern '[0-9]+' --text-to-match abc123")
    assert_match "matches:", output
    assert_match "123", output
  end
end
