class Countryfetch < Formula
  desc "Neofetch-like tool for fetching information about your country"
  homepage "https://github.com/nik-rev/countryfetch"
  url "https://github.com/nik-rev/countryfetch/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "a41f2108ab81af92a4a5550f87409fd0291c710b640fb8edea06392f8b669c4e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/nik-rev/countryfetch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fea5146281684a5469b1603522e8c8dfa6aae6617304fc2bb2c44b90294216fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e6cd4af5d1433176d308dc209633a4f97e78e68ad3b993ea8fd2c972a24ba76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "086e90f5d2278ae2d859db5e672faf7f02035beccac0a9e8900d94084d480feb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "130fce00abf6f369ed4263543dbcd1bf6f074151c9ae68a8cb1279f8585b699d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3019df9e023de4f31d4273bb1c2133479e65fe94403456204e680c13b12aa38a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    inreplace "Cargo.toml", 'openssl = { version = "0.10", features = ["vendored"] }', 'openssl = "0.10"'

    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["openssl@3"].opt_lib/"pkgconfig"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/countryfetch --version")

    output = shell_output("#{bin}/countryfetch --no-color --no-flag --no-palette Japan")
    assert_match "Japan", output
    assert_match "ISO Codes: JP / JPN", output
  end
end
