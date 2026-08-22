class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.4.tar.gz"
  sha256 "b5f5e20e215cdefab597103f21a13a1db8ff86fa3089349b9dd382dc44f16ac2"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8edc1eb922aa4d874f008cf8242b1f3f9a448b729eee1437e603338814149aae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46b60be4ec55a6c7be2f7680ec3d6972fb5e5090155019c9cb6667d2a33ba5e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee2b0893f226aeaf669d31940a83109b28480f3539e18d8c2204db24374fe984"
    sha256 cellar: :any,                 arm64_linux:   "b8a84e91d6f4d85b9738cce464f2ab4427b8f60372e74359ba9405ac39a55122"
    sha256 cellar: :any,                 x86_64_linux:  "74ee7964303e495ddc72fcb9b7fadd757ccaefcb748bdd462206ba97b907c119"
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
