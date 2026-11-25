class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://github.com/EthanBlackburn/tangent"
  url "https://github.com/EthanBlackburn/tangent.git",
      tag:      "v0.3.2",
      revision: "1659d603b1f9d5ab6073d85a3d004e3b783426d5"
  license "MPL-2.0"
  head "https://github.com/EthanBlackburn/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "6a5942ae8f3702292453656a5410c3756faf6b45a53e031dba99dfe033c701a7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f706d86fc93eff3b6116039660603da4990216adab5fe687150c9b87240204f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1645873b778ec83b254d28ecc3ef8697e039b40d9cd6258764f693b01022daf6"
    sha256 cellar: :any,                 arm64_linux:   "f52971c17fe6f039ca1bf0f96e877953edd1c39b9551c5f58a630975c4d52b42"
    sha256 cellar: :any,                 x86_64_linux:  "742d253c12d31346b68fc22839b0c86162560d05406c2d22b64482dc8374e5f5"
  end

  depends_on "cmake" => :build # for rdkafka-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")
    ENV.prepend_path "CMAKE_PREFIX_PATH", formula_opt_prefix("openssl@3")
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tangent --version")

    output = shell_output("#{bin}/tangent plugin scaffold --name brewtest --lang ruby 2>&1", 1)
    assert_match "unsupported --lang ruby", output
  end
end
