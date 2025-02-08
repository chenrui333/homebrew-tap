class Rustfilt < Formula
  desc "Demangle Rust symbol names using rustc-demangle"
  homepage "https://github.com/luser/rustfilt"
  url "https://github.com/luser/rustfilt/archive/refs/tags/0.2.1.tar.gz"
  sha256 "f09bb822c8b22c4c89bf63cc64f8f85a053e1850a70cad4b7308e00871527496"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2858be553689a70c3fecacd4247a0e95047150050e51ecc5b09950b7d63acce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4205c1847d6595d4c0294c393d14fa36ee781c93859b6548e55f1ab397861f"
    sha256 cellar: :any_skip_relocation, ventura:       "11a4239bb38998922d0f0ee22e1e98149eab47dcb1db0c498f923d5de641efd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe814a3ab2b7fde4d208c567515f1b91911b792a514ab4c3ed5607bad373ece"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rustfilt --version")

    assert_equal "foo::bar::baz", shell_output("#{bin}/rustfilt _ZN3foo3bar3bazE").strip
  end
end
