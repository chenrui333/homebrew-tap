class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "342b576e3a6427389c449a146e5248fcffc52e7cd4212327d9a546c4bbb20b7f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e76bd575927c59ef10ce673ba3275cb24f2a133489d1125785cae1fc29f2889f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "782e334b9e97d7f8fab5af56c6dd348f16b55d44646b1a38a80f202c7d23a703"
    sha256 cellar: :any,                 arm64_linux:   "d366112a3708571f4b46d6c7972b522c32e151c4c81023bcb63eb89bf80558ed"
    sha256 cellar: :any,                 x86_64_linux:  "1422cfd51e2836b543c3e989c770146b7a9a1dd7abac70e491f73e8446bb8d1a"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "mandible")
    generate_completions_from_executable(bin/"mandible", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mandible --version")
    output = shell_output("#{bin}/mandible 2>&1", 1)
    assert_match "no tool given", output
  end
end
