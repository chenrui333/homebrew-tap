class Seednaut < Formula
  desc "Inspect and extract Seedvault backups"
  homepage "https://github.com/Baltram/seednaut"
  url "https://github.com/Baltram/seednaut/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "ee840d495e46b4e24a8f1778df7be18e55c1a493b334c03fdd3d1729bcca818b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/Baltram/seednaut.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5737fbf64aca7a42c57443d0d44bc9558f98beeb91987937945c27305224a806"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2de5ce4f8fc6b8a78fbc5e11c7afc8fdbf36887ca8cc060a4faffaf712f4af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dd1b117b901814745d0f091e950859f9223ddc58b41f608022f50358fa5a511"
    sha256 cellar: :any,                 arm64_linux:   "0cab93ba4e358d9e5028a854e49aba75cabf8ecdefcbc9995609cf1d94a60429"
    sha256 cellar: :any,                 x86_64_linux:  "9168d8c0652dff69d201cc5ab97279bcf05e919a44f9318d77f2fa03083f73e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/seednaut --version")
    output = shell_output("#{bin}/seednaut list #{testpath}/missing 2>&1", 1)
    assert_match "The specified input path does not exist", output
  end
end
