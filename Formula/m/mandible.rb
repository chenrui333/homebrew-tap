class Mandible < Formula
  desc "Interactive reference for installed command-line tools"
  homepage "https://github.com/AS-FOSS/mandible"
  url "https://github.com/AS-FOSS/mandible/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "432f2cfc1987e1e5a7bb096bf7e60c84581efb576dea317b8577c0f1c4ae6fcf"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/AS-FOSS/mandible.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f1df829595e719a071dc8927a7bdb1eaeefd2d72e0825380bf90955fa0af6d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "265e2aa78652262f334b454a0455152ba237ccdf8f088742e3bc4d2b786998d4"
    sha256 cellar: :any,                 arm64_linux:   "10d6d2445013daf81a10fa9098f0db6e54557ff1d61791f04b7428de9b9b2faa"
    sha256 cellar: :any,                 x86_64_linux:  "1f6c22b57b00d0f8aed5dfbc8d9488cf1c09ed72405e9d83a2e7a1ea0491973c"
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
