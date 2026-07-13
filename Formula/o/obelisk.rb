class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f47e036a6713b251945ca019eceb1f05aab334047c67d235e9c291cf00b46a98"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1064e0e16fef61364659d853707d803a61884c386e83133630c754794d61e0f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35b8249bf45b6e32338710ecc7b2e5339e2e113dd987202643957da337a6b22a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "878797c62accb39e8699ff5ede9449d937d8ed7c9b8423df87c487fce784c21e"
    sha256 cellar: :any,                 arm64_linux:   "e9b700ae39259f0a30b736284a601abca1e52f7dd73402e57f93dc562c69132d"
    sha256 cellar: :any,                 x86_64_linux:  "1ff507a1c488b7557052df73d874f77383bd6b3ff17977f6f0b479c999c9a9f2"
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
