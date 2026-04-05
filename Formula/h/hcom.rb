class Hcom < Formula
  desc "Let AI agents message, watch, and spawn each other across terminals"
  homepage "https://github.com/aannoo/hcom"
  url "https://github.com/aannoo/hcom/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "51900a05e56f21b0c8671b2b368fb3b494016a497f76c984944660b2158073d3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed06f354592411f4e61bc3b1cd8eb60a40321e2233ee172a1edf2b34e813bdd9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d08c5378adbe7849c006058920338aceca4751fb12eea317b206c22ad8f1a76c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daf90b96a37d23357a9290ece936a26457a8688fe9be9e38f2c55944128226d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "865bd2243c601d8471ee0793fa75f70e4d607ca7d0460ab2a8c7606780aab291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "194fa8edc339eb103df1bb8ea36522f4ad203197101a2ee56d9cc3d633c0097c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hcom --version")
  end
end
