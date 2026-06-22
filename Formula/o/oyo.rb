class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.36.tar.gz"
  sha256 "653d235c75797c271c95c5cca4dfdc1569c1d0a215f44cc53e7605efc8fd8ae3"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bb60252935c1fe60ecc066b630bb1c303115134ed6ff2bf865c213630940dde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7d28f4505604545e1ca69ee60f1175e2a08cb9050114a9e88bb1bf3c0fa8a69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "582330dcf787e1da038547920ccbf64e05e91743e8361576705fdc15652b28c8"
    sha256 cellar: :any,                 arm64_linux:   "b3cbc7754880c921d90fd8afc9a2ac41a55ae9e799a4b036cc913ddc6dfb355e"
    sha256 cellar: :any,                 x86_64_linux:  "768867542101cfbeeb0981bd8bec256f2009bd4e230288ebc82b8b201df46d6d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
