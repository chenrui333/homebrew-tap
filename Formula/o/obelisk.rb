class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.3.tar.gz"
  sha256 "f8d461e0f0c86e1202a551bcd49026cd298daca5b3a11c597e1d6c14b929f925"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa87edda880f49c38a482b2b506c5dcbed63a70b7491d173865cec4d499d8cf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1947ac857289b0da33d1cff855d183377ee493598a57d935d4209bc170283f55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede7ff1c50be9401a153a3602859a4ebf0ba873d1e51eaa61847b819ec9b3dd6"
    sha256 cellar: :any,                 arm64_linux:   "492b5b3f99189a41d4f4f3d4d5778f9a4953af93832a6ebe6b8919718d4aa443"
    sha256 cellar: :any,                 x86_64_linux:  "badb041332b16e3925acf983a6c54e5301df6eba774a11f41dc0a0ae179c2bc7"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
