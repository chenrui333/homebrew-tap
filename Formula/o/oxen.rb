class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "bd24151a09d5a1ad6fce0d65ebff3f8ed2011a7215909ccc8d8ad1a7740d4ecf"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bce2c5c5698abbbcaa5f68c512ed63c4c52476925c33fb5d54dc8aebf36ef32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "226b071802021653bf20f68cfab6b4d504d2e3ad9cbc3ffcc96a605a2da95b16"
    sha256 cellar: :any_skip_relocation, ventura:       "6167c8f14be31d13e0bc0c414297a9289911cb2d8a18c0be02ae61e7a2a5c81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5008e756f2fb438e52e92a2447da3a731c57418b74f505106ecd5c6a39d6cac"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end
