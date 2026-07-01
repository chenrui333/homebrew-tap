class Kyushu < Formula
  desc "Self-hostable Wasm sandbox for JavaScript workers"
  homepage "https://github.com/peterpeterparker/kyushu"
  url "https://github.com/peterpeterparker/kyushu/archive/refs/tags/cli/v0.3.0.tar.gz"
  sha256 "6ddc3492bb9fc5c34b2f6a6de11b16d187e5a82efa45d4df22443583d7aa06e4"
  license "MIT"
  head "https://github.com/peterpeterparker/kyushu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2f45ffd1d1bb6521cf8ffcd3b8c05a3b828f9a95976d893aff27647532ea336"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac467aa6cd117bfba5e50d8b2d9258ac7b9218f0a4826cfadf793e6409f4faa7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "51816986f712c22404a23d40b1389929e2d0a0884e81f18a397929fe5371d5c5"
    sha256 cellar: :any,                 arm64_linux:   "da10a2087cffb3d3301eb2b97434f5dc82b39715d364b6fc2caff164d2f3c13c"
    sha256 cellar: :any,                 x86_64_linux:  "65899efca5282f8f92b00cd557a5f9f7c83a705c54ecb181b8b08842f9faa8dd"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kyu --version")
    output = shell_output("#{bin}/kyu --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
