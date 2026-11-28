class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://github.com/EthanBlackburn/tangent"
  url "https://github.com/EthanBlackburn/tangent.git",
      tag:      "v0.3.4",
      revision: "f874220d1fb79bf2c265142f841b8b0c03f22ece"
  license "MPL-2.0"
  head "https://github.com/EthanBlackburn/tangent.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "485b93eef42a23e417c6813a223a8acb5c955938b3f4cabf2724ae350b0b7d2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82bb014ba63f3fde95631f1b84aed2565887babedf301b67a427f657f5aa52b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e8178a9daaacaff1913ec2357ea0a953353d6c403bdac3ef9db1b15ef9a2af2"
    sha256 cellar: :any,                 arm64_linux:   "22cddbe6386d510adb5de37527fc2fbafd8f302b412a41e20860392cdc89072a"
    sha256 cellar: :any,                 x86_64_linux:  "c589477d3a653430af3c60eeb37fc3f66172fe8750edded2eaeebc98260a99ac"
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
