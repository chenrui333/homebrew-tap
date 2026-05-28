class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.29.0.tar.gz"
  sha256 "ab383577ca94deab1bc1b343778aae1a1752b60115c91042feca9d2ca49c3516"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12d02de2a80d698dd2b353df10dbdd90e7b2e77ee7b09a019ed551135a2f7fe1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d663737940781f698c09eeb2dd709c7cb2c3c0b83f4f3dd67aa1422f157fe971"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddee85fccb4d8a972f89637191731ec79811d184a409efd6bb5b806d8452140a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "949c6b6aa1f667ceb0ba83a04d45f10c06d24a14066b99d34546ddfcb1a06532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc6f2a9b529d6fcc46c795092ef5e929a7b9f2a54a34993083a32ce03f7b1a08"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
