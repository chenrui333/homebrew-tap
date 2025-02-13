class Tuono < Formula
  desc "Superfast fullstack React framework"
  homepage "https://tuono.dev/"
  url "https://github.com/tuono-labs/tuono/archive/refs/tags/v0.17.8.tar.gz"
  sha256 "93d17fc4f9324d6a3c2da45f655750bf47da8a60bee3a49b0f152d4b55289935"
  license "MIT"
  head "https://github.com/tuono-labs/tuono.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edbc9ea97011cce2535a43ff5d80a7465db68356c873a54734581a998fd44f5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15ea88aa296c7b521eb65a8c89caf96171cd8fc08a3a019a9cbd626d2cfc4e45"
    sha256 cellar: :any_skip_relocation, ventura:       "de025bb0a8d36af4d8b910ec89fbbdc31caa9d59b2d2b7b48d4248ddf268f590"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acafd1fa278198dda6a0aa0362db29ef3bef6169e8adda8559788e6c723aae5b"
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
