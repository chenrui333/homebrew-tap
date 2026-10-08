class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6a4707445597e56eaf4010e2bfec3266c2e465e39fc13f44cb3ffdf451f844e6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "911f577305f282d40794403142f7b06cb75228e8bcf439392a8f5f707f6312df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ad90377da392b91c37ce58582312de9429957ab3a0f3a13cfa89417475ec33b"
    sha256 cellar: :any,                 arm64_linux:   "f609be9dff4c0543f4e0e32db2f7a3cd467c27aa8a1649004e268131054e606f"
    sha256 cellar: :any,                 x86_64_linux:  "b44977a56b46d3b9f9b88b5abd922be93d367a9ef0af0c6203e6956bf01d1858"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    inreplace "Cargo.toml", /^version = ".*"$/, "version = \"#{version}\""
    system "cargo", "install", *std_cargo_args(path: "zb_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zb --version")

    output = shell_output("#{bin}/zb --root #{testpath}/root --prefix #{testpath}/prefix init 2>&1")
    assert_match "Initialization complete!", output
    assert_path_exists testpath/"prefix/Cellar"
  end
end
