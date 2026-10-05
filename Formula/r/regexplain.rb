class Regexplain < Formula
  desc "Explain and visualize regular expressions"
  homepage "https://github.com/kapilpokhrel/regexplain"
  url "https://github.com/kapilpokhrel/regexplain/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "946bb593c24a9b1116ced80018657239377553882bb74fde96953244b9831194"
  license "MIT"
  head "https://github.com/kapilpokhrel/regexplain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af3264fabf297f2fdebf19b365a7ef1c0cda87bc76a0caa3d813ed00b69e2900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e66fc302c2d42a02778523a730d28492240122c5f6d927903bd02fbeb16748"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08efae144c3ef8ce3f2b68e1467ae9bb0e5e66f059f6061e0560bdc9c860e0b1"
    sha256 cellar: :any,                 arm64_linux:   "f15c3e80d02563acbb213a35782e353b79ada23d67885df24152a9be7c441e62"
    sha256 cellar: :any,                 x86_64_linux:  "5d09908d8e8e267e2f9d1ddf12ff4a8d98a729b09ce6380260c0c6e05b132f96"
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
