class Clickhousectl < Formula
  desc "CLI for ClickHouse: local and cloud"
  homepage "https://github.com/ClickHouse/clickhousectl"
  url "https://github.com/ClickHouse/clickhousectl/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "d342ad448816e65e9bb158b02caa4c5ce7c601c2edaa45195cda833edd50ff50"
  license "Apache-2.0"
  head "https://github.com/ClickHouse/clickhousectl.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95c06316da5fcd16fdb6f742e98408f0f44de69d1c0c30d364536d831fbc5a95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a3857c17113eaaf7d035511a5f31624bdc6583a0ae4d73b5997b004091f0f02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71ea720bad647424590bef86669db215530cd0baab0ab3473af27aec4b8c1330"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db20c3e828ea35136e0dd07c90c7edeb493f3a09abeb6cad9b518e12eaae628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4780a8a603e0d16b82621d956eb1bc023410f9aaa155e7e878dd9abe6175733c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/clickhousectl")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clickhousectl --version")

    output = shell_output("#{bin}/clickhousectl cloud auth status")
    assert_match "Not configured", output
  end
end
