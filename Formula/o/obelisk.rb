class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f47e036a6713b251945ca019eceb1f05aab334047c67d235e9c291cf00b46a98"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e31e1838186740c8c6b084c50f44a846b4d38526fc85c44c25ca9ed532995f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c0c05a7ad27b3904ac401c010cbbf9e183bf66f9a5dc909742937aec08824db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c98d7d2607f46170e7b267add5c8d0034482cc33082417c4c95783286ddff48"
    sha256 cellar: :any,                 arm64_linux:   "20bed02a1f3afe7d3c25a5a3623f41e12c8bd32e4fc40ac4f098bb445af6c7c6"
    sha256 cellar: :any,                 x86_64_linux:  "5630c1c2b5c6c197db5591e1dec27856d21a275bc7246ce32bde898050588fd0"
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
