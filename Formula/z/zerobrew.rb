class Zerobrew < Formula
  desc "Drop-in, faster, experimental Homebrew alternative"
  homepage "https://github.com/lucasgelfond/zerobrew"
  url "https://github.com/lucasgelfond/zerobrew/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "6a4707445597e56eaf4010e2bfec3266c2e465e39fc13f44cb3ffdf451f844e6"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/lucasgelfond/zerobrew.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90c7b7da54cb80136fb1ca22dfb4ccdb25fcbcdc8aba13e5f317f31dbe1c5904"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "749233640fe2b5e67e9cf711478951fef875e05c0857787c5573b5047b0a4839"
    sha256 cellar: :any,                 arm64_linux:   "8652648693e1a06ff0fb5d93b0995f8ea938e907ab2c82dea5dd04d014c883a3"
    sha256 cellar: :any,                 x86_64_linux:  "cfd427fa31888a6c86b50dcc37d73d3de1522616570c6e62ff6b5c0f3496fea7"
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
