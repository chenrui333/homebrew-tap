class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.23.2.tar.gz"
  sha256 "2d3262b71a7fe9721d3fd98e7824eff71016aa078e9059244f306e3e44a351ee"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d732a47efdfc267f747a42319f871d37e205bf458bdf5cb24627df9dcc9aff29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45a93bc492f35c7a0422d1f9067f30bdeb1f214471a4be1b4344113b9c0e1fde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7274ec09bfba66d4db7b632d879ce46d481f0e3171583c2c6b8a5e852478a174"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b85ed6df9c9ff87b6daf447b5bc13f35e2b09aa9db90e84bf85b460c09d7b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb0e4d4e063f084046799440f498b3bfc0d1ec667dab3332906a7755f4fe2856"
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
