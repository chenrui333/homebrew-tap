class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://github.com/EthanBlackburn/tangent"
  url "https://github.com/EthanBlackburn/tangent.git",
      tag:      "v0.2.0",
      revision: "c7b8f5feee9ed0fc52cab270ed08a726c6c3a4a4"
  license "MPL-2.0"
  head "https://github.com/EthanBlackburn/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "344bdd3a77c667109c07330ff2fb98b20d56e1d065baa50c7ede9b3b48fde204"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5201fe3da476f18bf0a42339308ea0b0664b08db8a50873d2c74c843f8145eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "854ec4f935ce6ac62a2a35e9619449100b3fbcd87eddafe2d4dfa9130c9bd65d"
    sha256 cellar: :any,                 arm64_linux:   "aed8265da89a290fc120c83d8760cf1a4219561baa78bfa4733f29715e72cfa8"
    sha256 cellar: :any,                 x86_64_linux:  "bcb5b6ba24bb7166843864b98db33543f5096fdb549694f4cf0beb2f2cf02091"
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
