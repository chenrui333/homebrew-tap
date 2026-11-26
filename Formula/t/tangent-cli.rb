class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://github.com/EthanBlackburn/tangent"
  url "https://github.com/EthanBlackburn/tangent.git",
      tag:      "v0.3.3",
      revision: "a84d45ecd38dc7c58f966947d9b08bb034f15775"
  license "MPL-2.0"
  head "https://github.com/EthanBlackburn/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "7c9d7549de327f03a198972282f0894b4cd9042cf3da9cce64f6d2997398a099"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be39a2319ba55ddf2664ed9b82c0f1ca3e511814be8824451ada93121a924a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3385aefa8018c8a7e0be4c69644fa93bf0d5b5812d16e54f1827ce3fc1eecb3f"
    sha256 cellar: :any,                 arm64_linux:   "36086565f3c419b3f47ae4446d2b90780c5b045d8c941b6fc420f781a0b38c78"
    sha256 cellar: :any,                 x86_64_linux:  "2ee62842329426fe3fbb1c43a7483393bc010c1e861e3dfc233c8f4f264b7478"
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
