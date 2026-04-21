class Xfr < Formula
  desc "Modern iperf3 alternative with a live TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://github.com/lance0/xfr/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "12db06825e50fdb28fadf4cc36c82360864485096124d8856e16c8a57869d13a"
  license "MIT"
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "713d74fc23e62865deca84b65050d145ecb766dcb5e30ab65af0a4c8e2c2dba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "876bc90bdfa371b8ce66f76d97471aff5941b5267ce48417b9ed810abe7b46a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e01490a80f05a4b20d09716054cca61cc7462fa1c25cd6cf65738e3bd0fef77f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3002a3c14224f7bf1e4fc214332faa271ca65d8f43a751711e5c553d49e21ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d6a0a3c7391828887c4507f2342e8c5a42d06b383627bf892c3f46f2e6b56b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xfr --version")
  end
end
