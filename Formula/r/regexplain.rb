class Regexplain < Formula
  desc "Explain and visualize regular expressions"
  homepage "https://github.com/kapilpokhrel/regexplain"
  url "https://github.com/kapilpokhrel/regexplain/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "946bb593c24a9b1116ced80018657239377553882bb74fde96953244b9831194"
  license "MIT"
  head "https://github.com/kapilpokhrel/regexplain.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "882330a7c7c064a5badbfae21680b92ec4fac32676d41a5ada4477b16da1b2ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa20df28878d4b72c8f3d8267070654d8273e843047faf30f6b391cefd4b352"
    sha256 cellar: :any,                 arm64_linux:   "6a4ceae4f7568d32c056b37e606732279b16a7bbb2f391501c70668f12329eba"
    sha256 cellar: :any,                 x86_64_linux:  "133ee7d7181bd36c26e04e932fbbe728929063d9cb35dded81798bdcadd440f3"
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
