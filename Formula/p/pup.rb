class Pup < Formula
  desc "CLI companion with 200+ commands across 33+ Datadog products"
  homepage "https://github.com/DataDog/pup"
  url "https://github.com/DataDog/pup/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "48aff94f87a4682ae6a4f675745cb3d9aab9b59fe3ae8aa857a749788fb915ce"
  license "Apache-2.0"
  head "https://github.com/DataDog/pup.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218a0a33d41a1bd8eb0722e3d84ab6b11d4c3a1fb5bf5f857a62cb2e4d434df5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "481971b89b5bb0740ec4d2261b2e14f0c5d2f62682e6156de69ad2dc12b6a862"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11c80807131e659350967d8448dcac1208e3d97b1d8a17b32a26c23a5f287030"
    sha256 cellar: :any,                 arm64_linux:   "8fd2a68d3e82fb9252a365ab18c87df84f33690f78ba10dbc3165f70912d8581"
    sha256 cellar: :any,                 x86_64_linux:  "c6d46cb2a66d963cc2acf2d893c233d777aa3063d12db83a7d26a00a80697bc9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pup", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pup --version")
    assert_match "Use pup CLI or generate code", shell_output("#{bin}/pup skills list")
  end
end
