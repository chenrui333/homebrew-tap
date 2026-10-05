class Livediff < Formula
  desc "Watch file differences in the terminal"
  homepage "https://github.com/SoCkEt7/Livediff"
  url "https://github.com/SoCkEt7/Livediff/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "41b3d22f646cd16beadd4ff72868f76badf561f93c9996329c30ef6a40d576d7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/SoCkEt7/Livediff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "959102ef39c60dffda52066602f4fc8e12362ca1d55c3c34cfa6c69470c96a64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e8faa97f9f79b6e3075215db75435da30e90941e5f971c5c31616b07d9f133a"
    sha256 cellar: :any,                 arm64_linux:   "61cac08d3a3cebfd4a5a67944a4a3274968c507ed4319f8fc2fbcefd68961442"
    sha256 cellar: :any,                 x86_64_linux:  "4c760ac9429768848635c88b980faec51e69dc52f7f8271ddb13b921c38db415"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/livediff --version")
    output = shell_output("#{bin}/livediff --invalid-option 2>&1", 2)
    assert_match "unexpected argument '--invalid-option'", output
  end
end
