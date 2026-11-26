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
    manifest_sha256 "24aef3ae3fd30ab1fb1df016784aa3b2dd38b34b5ff235256633405257e5abc9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "613950eecb22930cf0c6566bb261d89a676be4a6e21ca5e2536a3ab92a899095"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "149c63121a050f0d5911df704c64423bd4207e88c6f3a86669a48d7f3a4fe07d"
    sha256 cellar: :any,                 arm64_linux:   "e36f56f0d9c9c3053bd08a40d82d69e29798168727d25883b43f87faa51c24eb"
    sha256 cellar: :any,                 x86_64_linux:  "007f8a7df1c3fae572b0b3ad9821f74d2aa56b1cea489dec939890090c625e78"
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
