class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "84b5f6d7407712a7e6c98c2b5dec3a025a31fadf7e58227b93e4fa6feef385d5"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a057c18bcdeb928dd8b74ca085ba618d698fa7d08ce49e7c7a69f397764a1a62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "076e016cd174af661e33e950ce766f5f041bde4ea7f8fc042fb958502352ad9b"
    sha256 cellar: :any,                 arm64_linux:   "6e2e9f6a4a0795ba26f8614361b89fa5458ee09ce8957e63b77c904ab96e2867"
    sha256 cellar: :any,                 x86_64_linux:  "eb3b34c37d4e90af34e9b33757da3fb255d8a83a0b31c93fa323870ed2bc3873"
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
