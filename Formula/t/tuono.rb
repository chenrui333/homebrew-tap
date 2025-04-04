class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.19.2.tar.gz"
  sha256 "53d9bc817536377e337d5fd63518ca4c0d9cbba3f351bbf637af49dde8e1e790"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dbf5fb5ceccd4ef1c1ccddb1d4f7f625ee3b8e2a91abd564bebf1148f9ad890"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b19843d292513630746235d4d02692afc6755db933c6a62bea1f0d17b1ea905"
    sha256 cellar: :any_skip_relocation, ventura:       "97b5caaaaacd845620026b90a56ba8438be8359d1e6f7b6a96fc574d9edf634c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaa238bf13c979d0d828f0651e9b265da3179591eac6ac59b912539df2e5cabc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/tuono")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuono --version")

    system bin/"tuono", "new", "my-app"
    assert_path_exists testpath/"my-app/package.json"
  end
end
